require 'maas/client/config'
require 'oauth'
require 'oauth/signature/plaintext'
require 'json'

module Maas
  module Client
    # A class that can be used to call MAAS API.
    class MaasClient
      attr_reader :access_token

      def initialize(api_key = nil, endpoint = nil)
        if api_key and endpoint
          @api_key = api_key
          @endpoint = endpoint
        elsif File.exists?(Maas::Client::Config.config[:conf_file])
          Maas::Client::Config.set_config
          @api_key = Maas::Client::Config.config[:maas][:key]
          @endpoint = Maas::Client::Config.config[:maas][:url]
        else
          abort("There is no server Info provided.")
        end
        @consumer_key = @api_key.split(/:/)[0]
        @key = @api_key.split(/:/)[1]
        @secret = @api_key.split(/:/)[2]
        consumer = OAuth::Consumer.new(
          @consumer_key,
          '',
          realm: '',
          site: @endpoint,
          scheme: :header,
          signature_method: 'PLAINTEXT'
        )
        @access_token = OAuth::AccessToken.new(
          consumer,
          @key,
          @secret
        )
      end

      def request(method, subject, param = nil)
        default_param = {
          'Accept' => 'application/json',
          'Content-Type' => 'multipart/form-data'
        }
        uri = '/' + subject.join('/') + '/'
        arguments = [method, uri, param, default_param].compact
        response = access_token.request(*arguments)

        return JSON.parse(response.body) if response.code == '200'

        if response.code == '204'
          puts 'No Content'
        else
          raise "#{response.class} #{response.code} \
            #{response.message} #{response.body}"
        end
      end
    end
  end
end
