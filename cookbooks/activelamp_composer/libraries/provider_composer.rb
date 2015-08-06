
require 'chef/provider'
require 'chef/exceptions'
require_relative 'resource_composer'

class Chef
  class Provider
    class Composer < Chef::Provider

      def load_current_resource
        @current_resource = @new_resource
      end

      def action_download_phar
        Chef::Log.info 'Downloading the Composer executable...'
        converge_by('Downloading Composer...') do
          execute = Chef::Resource::Execute.new('curl -sS https://getcomposer.org/installer | php', @run_context)
          execute.cwd(@current_resource.directory)
          execute.user(@current_resource.user)
          execute.group(@current_resource.group)
          execute.provider = Chef::Provider::Execute
          execute.run_action(:run)
        end
      end

      def action_self_update
        run_composer_command('self-update')
      end

      def action_update
        ensure_json_existence

        flags = []
        flags.push('--no-dev') unless @current_resource.dev
        flags.push('--no-scripts') if @current_resource.no_scripts
        flags.push('--prefer-source') if @current_resource.prefer_source
        flags.push('--prefer-dist') if @current_resource.prefer_dist
        flags.push('--optimize-autoloader') if @current_resource.optimize_autoloader

        run_composer_command('update --no-progress', flags)
      end

      def action_install

        ensure_lock_existence if @current_resource.lock_file_only
        flags = []
        flags.push('--no-dev') unless @current_resource.dev
        flags.push('--no-scripts') if @current_resource.no_scripts
        flags.push('--prefer-source') if @current_resource.prefer_source
        flags.push('--prefer-dist') if @current_resource.prefer_dist
        flags.push('--optimize-autoloader') if @current_resource.optimize_autoloader

        run_composer_command('install --no-progress', flags)
      end

      def action_dump_autoload

        flags = []
        flags.push('--no-dev') unless @current_resource.dev
        flags.push('--optimize') if @current_resource.optimize_autoloader

        run_composer_command('dump-autoload', flags)
      end

      def action_run_script
        run_composer_command("run-script #{ @current_resource.script }")
      end

      def ensure_json_existence
        raise Chef::Exceptions::StandardError, 'No composer.json found.' unless ::File.exists? "#{ @current_resource.directory }/composer.json"
      end

      def ensure_phar_existence
        raise Chef::Exceptions::StandardError, 'No composer.phar found.' unless ::File.exists? "#{ @current_resource.directory }/composer.phar"
      end

      def ensure_lock_existence
        raise Chef::Exceptions::StandardError, 'No composer.lock found.' unless ::File.exists? "#{ @current_resource.directory }/composer.lock"
      end

      def run_composer_command(cmd, flags=[])
        ensure_phar_existence
        full_command = "php composer.phar #{ cmd } #{ flags.join(' ') } --no-ansi --no-interaction #{ @current_resource.quiet ? '--quiet' : '' }"
        Chef::Log.info "Composer: Running #{ full_command }"
        converge_by("Executing #{full_command}") do
          execute = Chef::Resource::Execute.new(full_command, @run_context)
          execute.cwd(@current_resource.directory)
          execute.user(@current_resource.user)
          execute.group(@current_resource.group)
          execute.provider = Chef::Provider::Execute
          execute.run_action(:run)
        end
      end
    end
  end
end