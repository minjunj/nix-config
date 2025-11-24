{ pkgs, ... }:
{
    # NixOS has built-in modules to enable 1Password
    # along with some pre-packaged configuration to make
    # it work nicely. You can search what options exist
    # in NixOS at https://search.nixos.org/options

    # Enables the 1Password CLI
    programs._1password = { enable = true; };

    # Enables the 1Password desktop app
    programs._1password-gui = {
    enable = true;
    # this makes system auth etc. work properly
    polkitPolicyOwners = [ "minjunj" ];
    };
}
