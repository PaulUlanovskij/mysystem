{ inputs, config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        paviel = import ./home.nix;
      };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Kyiv";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };


    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    hardware = {
      opengl.enable = true;

      nvidia.modesetting.enable = true;
    };


    services.devmon.enable = true;

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };


    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;

    services.printing.enable = true;
    
   
sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    #media-session.enable = true;
    wireplumber.enable = true;

  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

    users.users.paviel = {
      isNormalUser = true;
      description = "paviel";
      extraGroups = [ "networkmanager" "wheel" "audio" "storage" ];
      packages = with pkgs; [
        firefox
      ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      neovim 
      obs-studio
      discord
      telegram-desktop
      aseprite

      ripgrep
      gitFull
      home-manager
      gnumake	
      rocmPackages.llvm.clang
      kitty
      feh
      waybar
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
      )
      libnotify
      mako
      swww

      networkmanagerapplet
      rofi-wayland

      ntfs3g
      pcmanfm
      usbutils
      udiskie
      udisks
    ];
services.gvfs.enable = true;
services.udisks2.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.05";

}
