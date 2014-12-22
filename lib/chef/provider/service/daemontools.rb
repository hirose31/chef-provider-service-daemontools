require "chef/provider/service/daemontools/version"

require 'chef/mixin/shell_out'
require 'chef/provider/service'
require 'chef/resource/service'
require 'chef/mixin/command'

class Chef
  class Resource
    class Service
      def directory(arg=nil)
        set_or_return(
          :directory,
          arg,
          :kind_of => [ String ]
        )
      end
      def service_dir(arg=nil)
        set_or_return(
          :service_dir,
          arg,
          :kind_of => [ String ]
        ) || '/service'
      end
    end
  end
end

class Chef
  class Provider
    class Service
      class Daemontools < Chef::Provider::Service
        include Chef::Mixin::ShellOut

        def initialize(new_resource, run_context=nil)
          super
          @svc_command    = 'svc'
          @svstat_command = 'svstat'
        end

        def load_current_resource
          @current_resource = Chef::Resource::Service.new(@new_resource.name)
          @current_resource.service_name(@new_resource.service_name)

          service_status!
          @current_resource
        end

        def enable_service
          if !@current_resource.enabled
            ::File.symlink(@new_resource.directory, "#{@new_resource.service_dir}/#{@new_resource.service_name}")
          end
        end

        def disable_service
          if @current_resource.enabled
            service_link = "#{@new_resource.service_dir}/#{@new_resource.service_name}"
            shell_out!("#{@svc_command} -dx . log; rm -f #{service_link}", :cwd => service_link)
          end
        end

        def start_service
          if @current_resource.enabled && !@current_resource.running
            shell_out!("#{@svc_command} -u #{@new_resource.service_dir}/#{@new_resource.service_name}")
          end
        end

        def stop_service
          if @current_resource.enabled && @current_resource.running
            shell_out!("#{@svc_command} -d #{@new_resource.service_dir}/#{@new_resource.service_name}")
          end
        end

        def reload_service
          if @current_resource.enabled && @current_resource.running
            shell_out!("#{@svc_command} -h #{@new_resource.service_dir}/#{@new_resource.service_name}")
          end
        end

        def restart_service
          if @current_resource.enabled && @current_resource.running
            shell_out!("#{@svc_command} -t #{@new_resource.service_dir}/#{@new_resource.service_name}")
          end
        end

        def service_status!
          service_link = "#{@current_resource.service_dir}/#{@current_resource.service_name}"
          if ::File.symlink?(service_link) && ::File.exist?("#{service_link}/run")
            @current_resource.enabled(true)
            status = shell_out!("#{@svstat_command} #{service_link}")
            if status.exitstatus == 0

              retry_count = 4
              while status.stdout =~ /: supervise not running/
                sleep 1
                retry_count -= 1
                status = shell_out!("#{@svstat_command} #{service_link}")
                break if retry_count < 0
              end

              if status.stdout =~ /: up \(pid [1-9]/
                @current_resource.running(true)
              elsif status.stdout =~ /: down [1-9]/
                @current_resource.running(false)
              else
                @current_resource.running(false)
              end
            else
              @current_resource.running(false)
            end
          else
            @current_resource.enabled(false)
            @current_resource.running(false)
          end

          @current_resource
        end
      end
    end
  end
end
