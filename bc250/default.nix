{ ... }:

{
  imports = [
    ../aic8800d80/module.nix
    ../bc250-cu-live-manager/module.nix
    ../cyan-skillfish-governor-smu/module.nix
  ];

  # AIC8800 support (USB WiFi/BT dongle)
  hardware.aic8800d80.enable = true;

  # Sensor support
  boot.kernelModules = [ "nct6683" ];
  boot.extraModprobeConfig = ''
    options nct6683 force=true
  '';

  # CU live manager
  services.bc250-cu-live-manager = {
    enable = true;
    boot.enable = true;
  };

  # GPU governor
  services.cyan-skillfish-governor-smu.enable = true;

  # zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
  };
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

}
