{
  config,
  lib,
  ...
}: {
  # MacBook/Asahi-only keyboard remapping.
  #
  # Import this module from the MacBook NixOS host only. Do not import it from
  # desktop hosts unless you explicitly want Command/Option-style remapping
  # there too.
  services.keyd = {
    enable = true;

    keyboards.macbook-internal = {
      # Replace "*" with the MacBook internal keyboard id from:
      #
      #   sudo keyd monitor
      #
      # Keep "*" only while initially testing on the MacBook, otherwise this
      # mapping will also affect external keyboards.
      ids = lib.mkDefault [ "*" ];

      settings.main = {
        # Make Command behave like Control, matching the desktop muscle memory.
        leftmeta = "leftcontrol";
        rightmeta = "rightcontrol";

        # Use only right Option as the Korean/English toggle.
        # Left Option remains Alt because it is intentionally not remapped.
        rightalt = "hangeul";
      };
    };
  };

  # keyd exposes a virtual keyboard. Marking it as internal preserves touchpad
  # palm rejection behavior on laptops.
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
