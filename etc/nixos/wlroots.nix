# Overrides the nixpkgs wlroots, used by whoever calls it.
# Nothing else on the config is affected, so other wlroots compositors
# keep their build unchanged.
#
# Defaults options:
#
# wlroots       = pkgs.wlroots;  wlroots package to use
# sanitize      = false;         builds with ASan and UBSan
# trace         = false;         builds keeping debug info for readable backtraces
# patches       = null;          applies patches from this folder, null for stock nixpkgs
# patchesExcept = [ ];           excludes patches that start with one of these strings
{
  lib,
  wlroots,

  sanitize ? false,
  trace ? false,
  patches ? null,
  patchesExcept ? [ ],
}:

let
  checkType =
    name: valid: takes: value:
    lib.throwIf (
      !valid value
    ) "wlroots.nix: ${name} takes ${takes}; got ${builtins.typeOf value}" value;

  checkedArgs = lib.deepSeq [
    (checkType "sanitize" lib.isBool "a bool, true builds with ASan and UBSan" sanitize)
    (checkType "trace" lib.isBool
      "a bool, true keeps debug info so backtraces out of wlroots resolve to file and line"
      trace
    )
    (checkType "patches" (value: value == null || lib.isPath value)
      "a path to a folder, whose *.patch files are applied on top of what nixpkgs already applies, or null to apply none"
      patches
    )
    (checkType "patchesExcept" (value: lib.isList value && lib.all lib.isString value)
      "a list of strings, each dropping every patch in `patches` whose filename starts with it"
      patchesExcept
    )
  ] null;

  selectedPatches = map (file: patches + "/${file}") (
    lib.filter (file: !(lib.any (prefix: lib.hasPrefix prefix file) patchesExcept)) (
      lib.optionals (patches != null) (
        lib.filter (lib.hasSuffix ".patch") (lib.attrNames (builtins.readDir patches))
      )
    )
  );

  asanCFlags = lib.concatStringsSep " " [
    "-fsanitize=address"
    "-fno-omit-frame-pointer"
    "-g"
    "-fsanitize=bounds-strict"
    "-fsanitize=float-divide-by-zero"
    "-fsanitize=pointer-compare"
    "-fsanitize=pointer-subtract"
    "-fsanitize-address-use-after-scope"
    "-fno-sanitize-recover=all"
    "-fsanitize-recover=float-divide-by-zero"
  ];

  traceCFlags = "-g -fno-omit-frame-pointer";

  cflags = lib.optional sanitize asanCFlags ++ lib.optional trace traceCFlags;
in
lib.seq checkedArgs (
  wlroots.overrideAttrs (
    prev:
    {
      patches = (prev.patches or [ ]) ++ selectedPatches;

      mesonFlags =
        (prev.mesonFlags or [ ])
        ++ lib.optionals sanitize [
          "-Db_sanitize=address,undefined"
          "-Db_lundef=false"
          # This is what is documented to be used with asan
          "-Doptimization=1"
          "-Ddebug=true"
        ];

      env = (prev.env or { }) // {
        NIX_CFLAGS_COMPILE = lib.concatStringsSep " " ([ (prev.env.NIX_CFLAGS_COMPILE or "") ] ++ cflags);
      };

      # so a fortify abort doesn't replace asan's report
      hardeningDisable =
        (prev.hardeningDisable or [ ])
        ++ lib.optionals sanitize [
          "fortify"
          "fortify3"
        ];

      dontStrip = sanitize || trace;
    }
    // lib.optionalAttrs (sanitize || trace) {
      version = prev.version + lib.optionalString sanitize "-asan" + lib.optionalString trace "-trace";
      __intentionallyOverridingVersion = true;
    }
  )
)
