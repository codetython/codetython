require 'rails_helper'

describe API::V1::UsersController do
  describe 'GET #show' do
    before(:each) do
      @user = create(:user)
      get :show, id: @user.id
    end

    it 'returns the information about the user' do
      expect(json_response[:email]).to eq(@user.email)
    end

    it { should respond_with :success }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for(:user)
        post :create, { user: @user_attributes }
      end

      it 'renders the user json object' do
        expect(json_response[:email]).to eq @user_attributes[:email]
      end
    end

    context 'when the user is not created' do
      before(:each) do
        @invalid_attributes = { password: '12345678', password_confirmation: '12345678' }
        post :create, { user: @invalid_attributes }
      end

      it 'renders a json errors' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = create(:user)
      api_authorization_header @user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, { id: @user.id, user: { email: 'test@example.com' } }
      end

      it 'renders the json object updated' do
        user_response = json_response
        expect(json_response[:email]).to eq('test@example.com')
      end

      it { should respond_with :success }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, { id: @user.id, user: { email: "testemail.com" } }
      end

      it 'renders a json errors' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        expect(json_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with :unprocessable_entity }
    end

  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = create(:user)
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }
    end

    it { should respond_with :no_content }
  end
end
