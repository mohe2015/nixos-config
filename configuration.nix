# safe impermanence setup: have a list of directories that should be persisting and have a script that checks whether there are files anywhere that are not in that list
# mount tmpfs or trash btrfs to places that we really dont want to persist (within these could be nested a persistent directory again)
# maybe another btrfs subvolume for data that can be easily reconstructed like /nix/store. Then we can easily snapshot all the data we find actually useful


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

#boot.kernelParams = ["amd_pstate=passive"];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam" "steam-original" "steam-run"
  ];

virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;


virtualisation.containers.enable = true;
  virtualisation = {
    docker.enable = true;
    #podman = {
    #  enable = true;##

      # Create a `docker` alias for podman, to use it as a drop-in replacement
   #   dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
    #  defaultNetwork.settings.dns_enabled = true;
    #};
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  systemd.oomd.enableUserSlices = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.amdgpu.amdvlk.enable = true;
  hardware.amdgpu.amdvlk.support32Bit.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moritz = {
    isNormalUser = true;
    description = "Moritz Hedtke";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.moritz = { pkgs, ... }: {
    accounts.email.accounts = {
      "Moritz.Hedtke@t-online.de" = {
        primary = true;
        address = "Moritz.Hedtke@t-online.de";
        userName = "Moritz.Hedtke@t-online.de";
        realName = "Moritz Hedtke";
        imap = {
          host = "secureimap.t-online.de";
          port = 993;
        };
        #signature.showSignature = "append";
        #signature.text = ''
        #  Viele Grüße
        #  Moritz Hedtke
        #'';
        smtp = {
          host = "securesmtp.t-online.de";
          port = 587;
        };
        thunderbird.enable = true;
      };
      "Moritz.Hedtke@stud.tu-darmstadt.de" = {
        address = "Moritz.Hedtke@stud.tu-darmstadt.de";
        userName = "mh58hyqa";
        realName = "Moritz Hedtke";
        imap = {
          host = "imap.stud.tu-darmstadt.de";
          port = 993;
        };
        signature.showSignature = "append";
        signature.text = ''
          Viele Grüße
          Moritz Hedtke
        '';
        smtp = {
          host = "smtp.tu-darmstadt.de";
          port = 465;
        };
        thunderbird.enable = true;
        # passwordCommand
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles.moritz = {
        isDefault = true;
      };
    };
    programs.git.enable = true;
    programs.git.userName = "Moritz Hedtke";
    programs.git.userEmail = "Moritz.Hedtke@t-online.de";
    programs.git.extraConfig = {
      init.defaultBranch = "main";
    };
    programs.bash.enable = true;
    programs.firefox.enable = true;
    programs.firefox.package = pkgs.firefox-bin;
    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscodium;
    home.packages = [pkgs.mission-center pkgs.verapdf pkgs.htop pkgs.libreoffice-fresh pkgs.ktorrent pkgs.python3 pkgs.jetbrains.pycharm-community pkgs.jetbrains.idea-community pkgs.tinymist pkgs.inkscape pkgs.rustup pkgs.clang_18 pkgs.pkg-config pkgs.file ];
    programs.chromium.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;
  fonts.packages = [ pkgs.roboto ];
  fonts.fontDir.enable = true;

  services.flatpak.enable = true;

  # can break system audio, dont use
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
