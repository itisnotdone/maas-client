# frozen_string_literal: true
require 'spec_helper'

describe Maas::Client::MaasClient, :aggregate_failures do
  sample_user = 'someone'

  user_info = {
    'username' => sample_user,
    'email' => "#{sample_user}@example.com",
    'password' => 'userpassword',
    'is_superuser' => 1
  }

  if ENV['API_KEY'] && ENV['MAAS_SERVER']
    subject = Maas::Client::MaasClient.new(
      ENV['API_KEY'].to_s,
      "http://#{ENV['MAAS_SERVER']}/MAAS/api/2.0"
    )
  else
    key = 'A:B:C'
    maas_server = 'http://maas.example.com/MAAS/api/2.0'
    before(:each) do
      subject = Maas::Client::MaasClient.new(key, maas_server)
      allow(subject).to receive(:request)
        .with(:get, ['wrongurl'])
        .and_raise(RuntimeError)
      allow(subject).to receive(:request)
        .with(:get, ['users'])
        .and_return([])
      allow(subject).to receive(:request)
        .with(:post, ['users'], user_info)
        .and_return(user_info)
      allow(subject).to receive(:request)
        .with(:delete, ['users', sample_user])
        .and_return(nil)
    end
  end

  context 'basic' do
    it 'has a version number' do
      require 'maas/client/version'
      expect(Maas::Client::VERSION).not_to be nil
    end

    it 'has an access token' do
      expect(subject.access_token)
        .to be_an_instance_of(OAuth::AccessToken)
    end

    it 'can report for wrong requests' do
      expect { subject.request(:get, ['wrongurl']) }
        .to raise_error(RuntimeError)
    end
  end

  context 'user list' do
    let(:user_list) { subject.request(:get, ['users']) }

    it 'returns an array' do
      expect(user_list).to be_an_instance_of(Array)
    end

    it 'has user information' do
      user_list.each do |user|
        expect(user).to include(
          'username',
          'resource_uri',
          'is_superuser',
          'email'
        )
      end
    end
  end

  context 'user management' do
    it 'can create a new user' do
      expect(subject.request(:post, ['users'], user_info))
        .to include('username' => sample_user)
    end

    it 'can delete a user' do
      expect(subject.request(:delete, ['users', sample_user]))
        .to eq(nil)
    end
  end
end
