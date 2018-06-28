require 'maas/client/config'
require 'oauth'
require 'oauth/signature/plaintext'
require 'oauth/request_proxy/typhoeus_request'
require 'json'
require 'hashie'
require 'typhoeus'

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
          @consumer_key, '',
          {
            :site => @endpoint,
            :scheme => :header,
            :signature_method => "PLAINTEXT"
          }
        )

        @access_token = OAuth::AccessToken.new(
          consumer,
          @key,
          @secret
        )
      end

      def request(method, subject, param = nil)

        headers = {Accept: 'application/json'}

        uri = access_token.consumer.options[:site] + 
          '/' + 
          subject.join('/') + 
          '/'


        oauth_params = {
          :consumer => access_token.consumer, 
          :token => access_token
        }

        hydra = Typhoeus::Hydra.new

        Hashie.symbolize_keys! param if param

        options = {
          method: method,
          headers: headers
        }

# https://github.com/typhoeus/typhoeus#sending-params-in-the-body-with-put
        if method == :get
          options.merge!({params: param})
        elsif method == :post
          options.merge!({body: param})
          headers.merge!(
            {'Content-Type'=> "application/x-www-form-urlencoded"}
          )
        end

        req = Typhoeus::Request.new(uri, options)

        oauth_helper = OAuth::Client::Helper.new(
          req,
          oauth_params.merge(
            {
              request_uri: uri,
              signature_method: access_token
              .consumer
              .options[:signature_method]
            }
          )
        )

        req.options[:headers].merge!(
          { "Authorization" => oauth_helper.header }
        )

        hydra.queue(req); hydra.run
        response = req.response

        return JSON.parse(response.body) if response.code == 200

        if response.code == 204
          puts 'No Content'
        else
          raise "#{response.class} #{response.code} \
            #{response.status_message} #{response.body}"
        end
      end
    end
  end
end
