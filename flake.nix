{
  description = "Matlab/GNU Octave Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
    octave = pkgs.octaveFull.withPackages (octavePackages: with octavePackages; [
      audio
      image
      linear-algebra
      ltfat
      matgeom
      symbolic
    ]);
  in
  {
    devShells."${system}".default = pkgs.mkShell {
      packages = [
        octave
        pkgs.entr
        pkgs.texliveFull
        pkgs.gnumake
        pkgs.pandoc
      ];

      INFOPATH = "${octave}/share/info";
    };
  };
}
