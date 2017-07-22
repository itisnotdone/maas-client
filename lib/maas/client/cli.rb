require 'thor'
require 'maas/client'
require 'maas/client/util'
require 'pry'
require 'yaml'

module Maas
  module Client
    class CLI < Thor
      package_name 'maas-client'
      # DO NOT DUPLICATE EXISTING 'maas' COMMAND.
      include Maas::Client::Util

      attr_accessor :conn

      def initialize(*args)
        super
        @conn = init_rbmaas
      end

      no_commands do
        def init_rbmaas
          user_rbmaas_home = Dir.home + '/.rbmaas'
          maas_config = {}
          maas_config[:user_rbmaas_home] = user_rbmaas_home
          if not File.directory?(user_rbmaas_home)
            puts 'Creating home directory..'
            FileUtils.mkdir(user_rbmaas_home)
          end

          lib_dir = Gem::Specification.find_by_name("maas-client").gem_dir
          maas_config[:lib_dir] = lib_dir
          conf_file = user_rbmaas_home + '/rbmaas.yml'
          if not File.exists?(conf_file)
            src = File.new(lib_dir + '/lib/maas/client/template/rbmaas.yml')
            dst = Dir.new(user_rbmaas_home)
            puts 'Copying sample rbmaas.yml..'
            FileUtils.cp(src, dst)
            abort("Please define default configuration for rbmaas at #{conf_file}")
          end

          maas_config.merge!(symbolize_keys(YAML.load_file(conf_file)))
          conn = Maas::Client::MaasClient.new(
            maas_config[:maas][:key],
            maas_config[:maas][:url]
          )
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
            abort("There is no dnsresource to clear.")
          end

          domains.each do |d|
            puts "Deleting #{d[:fqdn]}..."
            conn.request(:delete, ['dnsresources', d[:id].to_s])
          end
        else
          puts "To clear #{resource} is not available."
        end
      end

      desc 'generate', "Generate custom data."
      def generate(resource)
        case resource
        when 'hosts'
          records = []
          conn.request(:get, ['dnsresources']).each do |d|
            records << { ip: d['ip_addresses'][0]['ip'], fqdn: d['fqdn'] }
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
        else
          puts "To generate #{resource} is not available."
        end
      end
    end
  end
end

