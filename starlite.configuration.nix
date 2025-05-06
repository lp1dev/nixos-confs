# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Sensors
  hardware.sensor.iio.enable = true;

  # Setting fwupd service
  services.fwupd.enable = true;

  services.udev.extraHwdb = ''
  sensor:modalias:acpi:KIOX000A*:dmi:*:*
    ACCEL_MOUNT_MATRIX=1, 0, 0; 0, -1, 0; 0, 0, 1;
    ACCEL_LOCATION=display
  '';

  # TPM Service taking too much time
  systemd.tpm2.enable = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Using intel integrated GPU
  boot.kernelParams = [ "i915.force_probe=4d60" ];
  services.xserver.videoDrivers = [ "modesetting" ];

  # Fixing to a specific kernel to fix my issues with BLE on Starlite MK V
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  # GPU acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
       vpl-gpu-rt  # for newer GPUs on NixOS <= 24.05
    ];
  };

  # Activating waydroid
  virtualisation.waydroid.enable = true;

  networking.hostName = "starlite"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enabla flatpak
  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  users.users.lp1 = {
    isNormalUser = true;
    description = "Jeremie A";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	emacs-nox
	git
	#vscode (use the flatpak version instead)
	#parsec-bin (use the flatpak version instead)
	python3
	virtualenv
	docker
	openjdk
	typst
	p7zip
	zip
	unzip
	pciutils
	cmake
	esptool
	file
    ];
  };


  # Installing steam
  programs.steam = {    
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
  };      

  # Enabling Docker
  virtualisation.docker.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Enable adb
  programs.adb.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     pkgs.ollama
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
