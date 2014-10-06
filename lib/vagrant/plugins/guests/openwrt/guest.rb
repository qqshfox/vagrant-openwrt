require "vagrant"

module VagrantPlugins
  module GuestOpenWrt
    class Guest < Vagrant.plugin("2", :guest)
      def detect?(machine)
        machine.communicate.test("cat /etc/openwrt_release | grep 'OpenWrt'")
      end
    end
  end
end
