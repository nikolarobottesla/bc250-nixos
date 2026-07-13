{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.aic8800d80;
  firmwareDirs = [
    "aic8800"
    "aic8800D80"
    "aic8800D80N"
    "aic8800D80X2"
    "aic8800DC"
    "aic8800DLN"
  ];
in
{
  options.hardware.aic8800d80 = {
    enable = lib.mkEnableOption "AIC8800D80 USB Wi-Fi/Bluetooth adapter support";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {
        kernel = config.boot.kernelPackages.kernel;
        utilLinux = pkgs.util-linux;
        usbModeswitch = pkgs.usb-modeswitch;
      };
      defaultText = lib.literalExpression ''
        pkgs.callPackage ./package.nix {
          kernel = config.boot.kernelPackages.kernel;
          utilLinux = pkgs.util-linux;
          usbModeswitch = pkgs.usb-modeswitch;
        }
      '';
      description = "Package providing the AIC8800D80 kernel modules, firmware, udev rules, and usb_modeswitch data.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.package ];
    boot.kernelModules = [ "aic_load_fw" "aic8800_fdrv" "btusb" ];

    hardware.firmware = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    hardware.bluetooth.enable = lib.mkDefault true;

    systemd.tmpfiles.rules = map (dir:
      "L+ /lib/firmware/${dir} - - - - ${cfg.package}/lib/firmware/${dir}"
    ) firmwareDirs;

    environment.etc."usb_modeswitch.d/1111:1111".source = "${cfg.package}/etc/usb_modeswitch.d/1111:1111";
    environment.systemPackages = [ pkgs.usb-modeswitch ];
  };
}
