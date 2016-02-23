require 'rails_helper'

describe User do
  before { @user = build(:user) }

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  context 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
    it { should_not allow_value('exampledomain.com').for(:email) }
    it { should validate_uniqueness_of(:auth_token)}
  end

  describe '#generate_auth_token!' do
    it 'generates an unique token' do
      allow(Devise).to receive(:friendly_token).and_return('uniquetoken001')
      @user.generate_auth_token!
      expect(@user.auth_token).to eq 'uniquetoken001'
    end

    it 'generates another token when one already has been taken' do
      existent_user = create(:user, auth_token: "uniquetoken001")
      @user.generate_auth_token!
      expect(@user.auth_token).not_to eql existent_user.auth_token
    end
  end
end
