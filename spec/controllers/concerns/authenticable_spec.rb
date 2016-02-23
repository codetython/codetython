require 'rails_helper'
class Authentication < ActionController::Base
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_user' do
    before do
      @user = create(:user)
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eq(@user.auth_token)
    end
  end

  describe '#authenticate_with_token' do
    before do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(authentication).to receive(:render) { |args| args }
    end

    it 'returns error' do
      expect(authentication.authenticate_with_token![:json][:errors]).to eq 'Not authenticated'
    end

    it 'returns unauthorized status' do
      expect(authentication.authenticate_with_token![:status]).to eq :unauthorized
    end
  end

  describe "#user_signed_in?" do
    context "when there is a user in the session" do
      before do
        @user = create(:user)
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        @user = create(:user)
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end
