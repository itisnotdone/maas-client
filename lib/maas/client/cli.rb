require 'thor'
require 'maas/client'
require 'maas/client/config'

module Maas
  module Client
    class CLI < Thor
      package_name 'maas-client'
      # DO NOT DUPLICATE EXISTING 'maas' COMMAND.
      attr_reader :conn

      def initialize(*args)
        super
        @conn = init_rbmaas
      end

      no_commands do
        def init_rbmaas
          maas_config = Maas::Client::Config.config
          if File.exists?(maas_config[:conf_file])
            Maas::Client::Config.set_config
            Maas::Client::MaasClient.new(
              maas_config[:maas][:key],
              maas_config[:maas][:url]
            )
          else
            Maas::Client::Config.init_config
          end
        end
      end

      desc 'clear', "Clear unused resources."
      def clear(resource)
        case resource
        when 'dns'
          domains = []
          conn.request(:get, ['dnsresources']).each do |d|
            if d['ip_addresses'] == [] or d['ip_addresses'][0]['ip'] == nil
              domains << {id: d['id'], fqdn: d['fqdn']}
            end
          end

          if domains == []
            puts "There is no dnsresource to clear."
            return nil
          end

          domains.each do |d|
            puts "Deleting #{d[:fqdn]}..."
            # use Thor basic functions such as 'ask' or 'say'
            answer = ask(
              'Do you really want to delete this?',
              :echo => true,
              :limited_to => ['y', 'n']
            )
            case answer
            when 'y'
              conn.request(:delete, ['dnsresources', d[:id].to_s])
            when 'n'
              puts "Canceling to delete #{d[:fqdn]}..."
            end
          end
        else
          puts "To clear #{resource} is not available."
        end
      end

      desc 'generate', "Generate custom data."
      def generate(resource)
        # clear dnsresources before generation
        invoke :clear, ['dns']
        case resource
        when 'hosts'
          records = []
          conn.request(:get, ['dnsresources']).each do |d|
            records << { ip: d['ip_addresses'][0]['ip'], fqdn: d['fqdn'] }
          end

          conn.request(:get, ['machines']).each do |m|
            if m['ip_addresses'] != []
              records << { ip: m['ip_addresses'][0], fqdn: m['fqdn'] }
            end
          end

          records.sort_by! { |h| h[:fqdn] }
          domain = conn.request(:get, ['domains'])[0]['name']
          to_slice = ".#{domain}"
          records.each do |r|
            hostname = r[:fqdn].gsub(to_slice, '')
            # to except the records for physical interfaces
            # such as eth0.10.foo.example.com
            if hostname.split('.').length < 3
              printf "%-20s %-20s %s\n", r[:ip], hostname, r[:fqdn]
            end
          end
          puts "# Updated date: #{Time.now.to_s}"
        else
          puts "To generate #{resource} is not available."
        end
      end
    end
  end
end

