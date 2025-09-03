# =========================================================================
#      Orange Pi 5 Specific Configuration
# =========================================================================
{
  pkgs,
  lib
  ...
}:
{
  imports = [
    ./base.nix
    ./dtb-install.nix
  ];

  boot = {
    kernelPackages = pkgsKernel.linuxPackages_6_16;

    # kernelParams copy from Armbian's /boot/armbianEnv.txt & /boot/boot.cmd
    kernelParams = lib.mkBefore [
      "rootwait"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=ttyS2,1500000" # serial port
      "console=tty1" # HDMI

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # orange pi 5's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-orangepi-5.dtb";
      overlays = [ ];
    };

    firmware = [
      (pkgs.callPackage ../../pkgs/orangepi-firmware { })
    ];
  };
}
