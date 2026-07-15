# bc250-nixos

Simple NixOS module for BC250. Comes with wrapper modules and recommended settings for:
 - CPU governor (Cyan Skillfish SMU)
 - ZRam
 - CU unlocking (bc250-cu-live-manager)
    - Make sure to test the stability of your CU unlock before enabling this

Also comes with a wrapper for the AIC8800d80 driver, a chipset used in some WiFi dongles.

## Usage

### As a NixOS module

```nix
{
  imports = [
    ./path/to/bc250-nixos
  ];

  # Required if enabling hardware.bc250.features.aic8800d80,
  # because that package includes redistributable binary firmware.
  nixpkgs.config.allowUnfree = true;

  hardware.bc250 = {
    enable = true;

    features = {
      # Disabled by default
      aic8800d80.enable = false;
      cuLiveManager.enable = false;

      # Enabled by default
      sensors.enable = true;
      governor.enable = true;
      zram.enable = true;
    };
  };
}
```

### As a NixOS module in a Flake

Add this input :
```nix
inputs = {
  bc-250.url = "github:TesseractCat/bc250-nixos"
}
```

Then load the module into your config :
```nix
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      modules = [
          bc-250.nixosModules.bc250
      ]
    }
```

Now you can use it in your configuration:
```nix
 { pkgs, ... }:{
  
    hardware.bc250 = {
    enable = true;

    features = {
      # Disabled by default
      aic8800d80.enable = false;
      cuLiveManager.enable = false;

      # Enabled by default
      sensors.enable = true;
      governor.enable = true;
      zram.enable = true;
    };
  };
 }

```