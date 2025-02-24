{ lib, pkgs, config, ... }: let
  inherit (lib) mkIf;
  inherit (config) conf;
  inherit ((pkgs.formats.elixirConf { }).lib) mkMap;
  neocat = (pkgs.callPackage ./neocat.nix { });
  neofox = (pkgs.callPackage ./neofox.nix { });
  blobfox = (pkgs.callPackage ./blobfox.nix { });
  blobhaj = (pkgs.callPackage ./blobhaj.nix { });
  # blobhajFlags = (pkgs.callPackage ./blobhajFlags.nix { });
in mkIf conf.fedi.enable {
  services.akkoma = {
    enable = true;
    config = {
      ":pleroma" = {
        ":instance" = {
          name = "miras fedi";
          description = "miras akkoma instance";
          email = "fedi@chpu.eu";
          registration_open = false;
        };

        # Initial block list copied from void.rehab
        ":mrf_simple" = {
          reject = mkMap {
            "1611.social" = "antisemitism";
            "5dollah.click" = "racism";
            "aspublic.org" = "privacy violation";
            "annihilation.social" = "bigotry";
            "bae.st" = "racism";
            "baraag.net" = "unmarked lolisho";
            "boymoder.biz" = "spam";
            "bv.umbrellix.org" = "harassment";
            "catposter.club" = "bigotry";
            "cawfee.club" = "racism";
            "childlove.space" = "csam";
            "clew.lol" = "racism";
            "clubcyberia.co" = "racism";
            "cum.salon" = "spam, privacy violation";
            "decayable.ink" = "racism";
            "detroitriotcity.com" = "racism";
            "eientei.org" = "racism";
            "eveningzoo.club" = "transphobia";
            "fluf.club" = "bigotry";
            "freeatlantis.com" = "transphobia";
            "freespeechextremist.com" = "racism";
            "freesoftwareextremist.com" = "racism";
            "fsebugoutzone.org" = "transphobia";
            "gameliberty.club" = "racism";
            "genderheretics.xyz" = "transphobia";
            "geofront.rocks" = "transphobia";
            "gleasonator.com" = "transphobia";
            "gh0st.live" = "bigotry";
            "h5q.net" = "unmarked lolisho";
            "h-i.social" = "antisemitism";
            "iddqd.social" = "racism";
            "lab.nyanide.com" = "racism";
            "linuxrocks.online" = "";
            "minds.com" = "racism";
            "momostr.pink" = "nostr bridge";
            "mostr.pub" = "nostr bridge";
            "mrhands.horse" = "racism";
            "mugicha.club" = "racism";
            "na.social" = "bigotry";
            "nationalist.social" = "racism";
            "newsmast.community" = "privacy violation";
            "nicecrew.digital" = "racism";
            "noauthority.social" = "racism";
            "norwoodzero.net" = "racism";
            "parcero.bond" = "racism";
            "pawoo.net" = "csam";
            "starnix.network" = "racism";
            "plagu.ee" = "racism";
            "pleroma.adachi.party" = "racism";
            "poa.st" = "racism";
            "probablyfreespeech.com" = "no incoming deletes";
            "rape.pet" = "i really don't want to have to explain this to you";
            "rebased.taihou.website" = "racism";
            "ryona.agency" = "antisemitism";
            "sacred.harpy.faith" = "racism";
            "seal.cafe" = "transphobia";
            "soc0.outrnat.nl" = "antisemitism";
            "strelizia.net" = "racism";
            "taihou.website" = "racism";
            "the.asbestos.cafe" = "bigotry";
            "thebag.social" = "bigotry";
            "threads.net" = "i mean";
            "tsundere.love" = "bigotry";
            "ubiqueros.com" = "antisemitism";
            "whinge.town" = "racism";
            "youjo.love" = "unlabelled nsfw";
            "youjo.observer" = "sexual harassment";
            "qoto.org" = "everything";
            "quietplace.xyz" = "slurs";
            "zhub.link" = "homophobia";
          };
        };

        "Pleroma.Web.Endpoint" = {
          url.host = "fedi.twoneis.site";
        };

        "Pleroma.Upload" = {
          base_url = "https://fedi.twoneis.site/media/";
        };
      };
    };
    extraStatic = {
      "emoji/neocat" = neocat;
      "emoji/neofox" = neofox;
      "emoji/blobfox" = blobfox;
      "emoji/blobhaj" = blobhaj;
      # "emoji/blobhajFlags" = blobhajFlags;
    };
    nginx = {
      serverName = "fedi.twoneis.site";
      useACMEHost = "twoneis.site";
      forceSSL = true;
    };
  };
}
