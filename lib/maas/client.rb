# require 'maas/client/version'
require 'oauth'
require 'oauth/signature/plaintext'
require 'json'
require 'pry'

module Maas
  module Client
    # A class that can be used to call MAAS API.
    class MaasClient
      attr_reader :access_token

      def initialize(api_key, endpoint)
        @api_key = api_key
        @consumer_key = @api_key.split(/:/)[0]
        @key = @api_key.split(/:/)[1]
        @secret = @api_key.split(/:/)[2]
        @endpoint = endpoint
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

      def request(method, uri, param = nil)
        default_param = { 'Accept' => 'application/json' }
        arguments = [method, uri, param, default_param].compact
        response = access_token.request(*arguments)

        if response.code == '200'
          return JSON.parse(response.body)
        elsif response.code == '204'
          puts "No Content"
        else
          raise "#{response.class} #{response.code} \
            #{response.message} #{response.body}"
        end
      end
    end
  end
end
