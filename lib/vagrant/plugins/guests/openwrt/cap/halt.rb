module VagrantPlugins
  module GuestOpenWrt
    module Cap
      class Halt
        def self.halt(machine)
          machine.communicate.execute("poweroff")
        rescue IOError
          # Do nothing, because it probably means the machine shut down
          # and SSH connection was lost.
        end
      end
    end
  end
end
