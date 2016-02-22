require 'rails_helper'

describe API::V1::SessionsController do
  describe 'POST #create' do
    before(:each) do
      @user = create(:user)
    end

    context 'when the credentials are right' do
      before(:each) do
        credentials = { email: @user.email, password: @user.password }
        post :create, { session: credentials }
      end

      it 'returns the user record of the given credentials' do
        @user.reload
        expect(json_response[:auth_token]).to eq(@user.auth_token)
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are wrong' do

      before(:each) do
        credentials = { email: @user.email, password: 'wrongpassword' }
        post :create, { session: credentials }
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, id: @user.auth_token
    end

    it { should respond_with 204 }
  end
end
