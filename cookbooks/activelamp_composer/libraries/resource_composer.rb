
require 'chef/resource'
require_relative 'provider_composer'

class Chef
  class Resource
    class Composer < Chef::Resource
      def initialize(name, run_list=nil)
        super
        @resource_name = :composer
        @directory = name
        @allowed_actions = [ :download_phar, :install, :update, :dump_autoload, :run_script, :self_update, :nothing ]
        @default_action = :install
        @lock_file_only = false
        @dev = true
        @verbosity = 1
        @quiet = true
        @user = nil
        @group = nil
        @script = ''
        @no_scripts = false
        @prefer_dist = false
        @prefer_source = false
        @optimize_autoloader = false
      end

      def directory(arg=nil)
        set_or_return(:directory, arg, :kind_of => String)
      end

      def lock_file_only(arg=nil)
        set_or_return(:lock_file_only, arg, :kind_of => [TrueClass, FalseClass])
      end

      def dev(arg=nil)
        set_or_return(:dev, arg, :kind_of => [TrueClass, FalseClass])
      end

      def verbosity(arg=nil)
        set_or_return(:verbosity, arg, :kind_of => Fixnum, :regex => /[1-3]/)
      end

      def quiet(arg=nil)
        set_or_return(:quiet, arg, :kind_of => [TrueClass, FalseClass])
      end

      def user(arg=nil  )
        set_or_return(:user, arg, :kind_of => String)
      end

      def group(arg=nil)
        set_or_return(:group, arg, :kind_of => String)
      end

      def script(arg=nil)
        set_or_return(:script, arg, :kind_of => String)
      end

      def no_scripts(arg=nil)
        set_or_return(:no_scripts, arg, :kind_of => [TrueClass, FalseClass])
      end

      def prefer_dist(arg=nil)
        set_or_return(:prefer_dist, arg, :kind_of => [TrueClass, FalseClass])
      end

      def prefer_source(arg=nil)
        set_or_return(:prefer_source, arg, :kind_of => [TrueClass, FalseClass])
      end

      def optimize_autoloader(arg=nil)
        set_or_return(:optimize_autoloader, arg, :kind_of => [TrueClass, FalseClass])
      end
    end
  end
end