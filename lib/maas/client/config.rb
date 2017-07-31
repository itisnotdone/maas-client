require 'maas/client/util'
require 'yaml'

module Maas
  module Client
    module Config
      extend Maas::Client::Util
      class << self
        attr_reader :config
      end

      @config = {}

      config[:lib_dir] = Gem::Specification.find_by_name("maas-client").gem_dir
      config[:user_rbmaas_home] = Dir.home + '/.rbmaas'
      config[:conf_file] = config[:user_rbmaas_home] + '/rbmaas.yml'

      def self.init_config
        if not File.directory?(config[:user_rbmaas_home])
          puts 'Creating home directory..'
          FileUtils.mkdir(config[:user_rbmaas_home])
        end

        if not File.exists?(config[:conf_file])
          src = File.new(config[:lib_dir] + '/lib/maas/client/template/rbmaas.yml')
          dst = Dir.new(config[:user_rbmaas_home])
          puts 'Copying sample rbmaas.yml..'
          FileUtils.cp(src, dst)
          abort("Please define default configuration for rbmaas at #{config[:conf_file]}")
        end
      end

      def self.set_config
        config.merge!(symbolize_keys(YAML.load_file(config[:conf_file])))
      end
    end
  end
end

