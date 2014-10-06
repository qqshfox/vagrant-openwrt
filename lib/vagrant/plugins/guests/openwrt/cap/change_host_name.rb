module VagrantPlugins
  module GuestOpenWrt
    module Cap
      class ChangeHostName
        def self.change_host_name(machine, name)
          new(machine, name).change!
        end

        attr_reader :machine, :new_hostname

        def initialize(machine, new_hostname)
          @machine = machine
          @new_hostname = new_hostname
        end

        def change!
          return unless should_change?

          update_etc_hostname
        end

        def should_change?
          new_hostname != current_hostname
        end

        def current_hostname
          @current_hostname ||= get_current_hostname
        end

        def get_current_hostname
          hostname = ""
          execute "uci get system.@system[0].hostname" do |type, data|
            hostname = data.chomp if type == :stdout && hostname.empty?
          end

          hostname
        end

        def update_etc_hostname
          execute(%{uci set system.@system[0].hostname="#{new_hostname}" && uci commit system})
        end

        def execute(cmd, &block)
          machine.communicate.execute(cmd, &block)
        end
      end
    end
  end
end
