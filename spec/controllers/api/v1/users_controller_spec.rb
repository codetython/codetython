require 'rails_helper'

describe API::V1::UsersController do
  before(:each) { request.headers['Accept'] = 'application/vnd.codetython.api' }

  describe 'GET #show' do
    before(:each) do
      @user = create(:user)
      get :show, id: @user.id, format: :json
    end

    it 'returns the information about the user' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(@user.email)
    end

    it { should respond_with :success }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for(:user)
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the user json object' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq @user_attributes[:email]
      end
    end

    context 'when the user is not created' do
      before(:each) do
        @invalid_attributes = { password: '12345678', password_confirmation: '12345678' }
        post :create, { user: @invalid_attributes }, format: :json
      end

      it 'renders a json errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with :unprocessable_entity }
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        @user = create(:user)
        patch :update, { id: @user.id, user: { email: "test@example.com" } }, format: :json
      end

      it 'renders the json object updated' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq('test@example.com')
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        @user = create(:user)
        patch :update, { id: @user.id, user: { email: "testemail.com" } }, format: :json
      end

      it 'renders a json errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end
end
