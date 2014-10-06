module VagrantPlugins
  module GuestOpenWrt
    module Cap
      class ConfigureNetworks
        def self.configure_networks(machine, networks)
          new(machine, networks).configure!
        rescue IOError
          # Do nothing, because it probably means the machine shut down
          # and SSH connection was lost.
        end

        attr_reader :machine, :networks

        def initialize(machine, networks)
          @machine = machine
          @networks = networks
        end

        def configure!
          lan = networks[0]
          execute "uci set network.lan.ipaddr='#{lan[:ip]}'"

          wan = networks[1]
          execute "uci add network interface"
          execute "uci rename network.@interface[-1]='wan'"
          execute "uci set network.wan.ifname='eth1'"
          execute "uci set network.wan.proto='#{wan[:type]}'"
          if wan[:type] != :dhcp
            execute "uci set network.wan.ipaddr='#{wan[:ip]}'"
            execute "uci set network.wan.netmask='#{wan[:netmask]}'"
          end

          execute "uci commit network && /etc/init.d/network reload"
        end

        def execute(cmd, &block)
          machine.communicate.execute(cmd, &block)
        end
      end
    end
  end
end
