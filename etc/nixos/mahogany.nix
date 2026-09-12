# Experimental nix package for mahogany
#
# Default options:
#
# rev           = "<git-rev>";   upstream commit to build, ignored when localSrc is set
# hash          = "sha256-...";  its hash, lib.fakeHash to have nix print the real one
# localSrc      = null;          build from this path instead, null fetches rev from github
# localRev      = null;          a ref inside localSrc to build, null builds its working tree
# patches       = null;          applies patches from this folder, null pulls using git
# patchesOnly   = [ ];           includes only patches whose filename starts with one of these strings
# patchesExcept = [ ];           excludes patches whose filename starts with one of these strings
# skipInitFile  = false;         passes -q, so ~/.config/mahogany/init.lisp is never loaded
# runTests      = false;         runs mahogany tests, stops on failure
# sanitize      = false;         builds with ASan and UBSan, if enabled it requires a sanitized wlroots
{
  lib,
  stdenv,
  fetchFromGitHub,
  # used for sanitize ASAN_SYMBOLIZER_PATH
  llvmPackages,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  sbcl,
  wayland-scanner,

  cairo,
  libdrm,
  libinput,
  libxcb,
  libxcb-wm,
  libxkbcommon,
  pango,
  pixman,
  wayland,
  wayland-protocols,
  wlroots_0_20,

  rev ? "fa91bd0c5bb0806991da5c3eb917e33a21812541",
  hash ? "sha256-ADc/4IPzEy44P7/EZ52oz+2BUwQjPPjMfLeX5Z2HxzE=",
  localSrc ? null,
  localRev ? null,
  patches ? null,
  patchesOnly ? [ ],
  patchesExcept ? [ ],
  skipInitFile ? false,
  runTests ? false,
  sanitize ? false,
}:

let
  checkType =
    name: valid: takes: value:
    lib.throwIf (
      !valid value
    ) "mahogany.nix: ${name} takes ${takes}; got ${builtins.typeOf value}" value;

  orNull = valid: value: value == null || valid value;
  isStringList = value: lib.isList value && lib.all lib.isString value;

  checkedArgs = lib.deepSeq [
    (checkType "rev" lib.isString "the upstream commit to fetch and build, as a 40-character sha string"
      rev
    )
    (checkType "hash" lib.isString
      "the SRI hash of that fetch, as a string -- lib.fakeHash to have nix print the real one"
      hash
    )
    (checkType "localSrc" (orNull lib.isPath)
      "a path to a checkout, built instead of the pinned rev, or null to fetch that rev from github"
      localSrc
    )
    (checkType "localRev" (orNull lib.isString)
      "a branch or ref name inside localSrc, as a string, or null to build its working tree"
      localRev
    )
    (checkType "patches" (orNull lib.isPath)
      "a path to a folder, whose *.patch files are applied to the source in filename order, or null to pull with git"
      patches
    )
    (checkType "patchesExcept" isStringList
      "a list of strings, each dropping every patch in `patches` whose filename starts with it"
      patchesExcept
    )
    (checkType "patchesOnly" isStringList
      "a list of strings, each adding every patch in `patches` whose filename starts with it"
      patchesOnly
    )
    (checkType "skipInitFile" lib.isBool
      "a bool, true passing -q so that ~/.config/mahogany/init.lisp is never loaded"
      skipInitFile
    )
    (checkType "runTests" lib.isBool
      "a bool, true running the test suite between building and installing and failing the build on a red one"
      runTests
    )
    (checkType "sanitize" lib.isBool
      "a bool, true building heart with ASan and UBSan and wrapping the binary with the environment they need"
      sanitize
    )
  ] (lib.throwIf (arrangementErrors != [ ]) (lib.head arrangementErrors) null);

  arrangementErrors = lib.filter (message: message != null) [
    patchesInsideLocalSrc
    wlrootsVersionWrong
    sanitizeMismatch
  ];

  wlrootsVersionWrong =
    if
      lib.versionOlder wlroots_0_20.version "0.20" || lib.versionAtLeast wlroots_0_20.version "0.21"
    then
      "mahogany.nix: wlroots_0_20 is version ${wlroots_0_20.version}, hrt-libs.lisp dlopens libwlroots-0.20.so by name. Pass a 0.20 build."
    else
      null;

  patchesInsideLocalSrc =
    if
      localSrc != null
      && localRev == null
      && patches != null
      && lib.hasPrefix (toString localSrc + "/") (toString patches + "/")
    then
      "mahogany.nix: patches is inside localSrc, since it's copied to the nix store, editing a patch would rebuild the lisp image from scratch. Move it out, or set localRev."
    else
      null;

  wlrootsSanitized = lib.any (lib.hasPrefix "-Db_sanitize=") (wlroots_0_20.mesonFlags or [ ]);

  sanitizeMismatch =
    if sanitize && !wlrootsSanitized then
      "mahogany.nix: sanitize is on but the wlroots_0_20 passed in has no -Db_sanitize. Pass a sanitized wlroots, or turn sanitize off."
    else if !sanitize && wlrootsSanitized then
      "mahogany.nix: the wlroots_0_20 passed in is sanitized but sanitize is off, so nothing sets LD_PRELOAD. Turn sanitize on, or pass a plain wlroots."
    else
      null;

  # When building from a localSrc with no pinned localRev to use,
  # this excludes temporary files, git files and any build/ folder from the source
  cleanedLocalSrc = lib.cleanSourceWith {
    name = "mahogany-local";
    src = lib.cleanSource localSrc;
    filter = path: type: !(type == "directory" && baseNameOf path == "build");
  };

  selectPatches =
    dir: pred:
    map (file: dir + "/${file}") (
      lib.filter pred (
        lib.optionals (dir != null) (
          lib.filter (lib.hasSuffix ".patch") (lib.attrNames (builtins.readDir dir))
        )
      )
    );

  matchesAny = prefixes: file: lib.any (prefix: lib.hasPrefix prefix file) prefixes;

  mahoganyPatches =
    if patchesExcept != [ ] && patchesOnly != [ ] then
      throw "mahogany.nix: patchesExcept and patchesOnly are both set, you can only use one at a time"
    else if patchesOnly != [ ] then
      selectPatches patches (matchesAny patchesOnly)
    else
      selectPatches patches (file: !(matchesAny patchesExcept file));

  cl-interactive = fetchFromGitHub {
    owner = "sdilts";
    repo = "cl-interactive";
    rev = "4bf73d69a2fe69119641ca8d99e035ca34208752";
    hash = "sha256-7kSK4JC1zyFIrb6ptElfXsi/VfE0xaBf1LE1DGAVgkI=";
  };

  cl-xkbcommon = fetchFromGitHub {
    owner = "sdilts";
    repo = "cl-xkbcommon";
    rev = "5e24ddaa10019ce3a261b6eb07e0a1cf12d317ef";
    hash = "sha256-a9UAr2BpnuNQpho0uIz8+nmdiEA6iG+wsHdGjVhVamI=";
  };

  sbclWithPkgs = sbcl.withPackages (
    ps:
    [
      ps.adopt
      ps.alexandria
      ps.atomics
      ps.bordeaux-threads
      ps.cffi
      # Required by cl-xkbcommon
      ps.cffi-grovel
      ps.cl-ansi-text
      ps.cl-colors2
      # Required by cl-interactive
      ps.closer-mop
      ps.float-features
      ps.fset
      ps.iterate
      ps.terminfo
      ps.trivial-garbage
    ]
    ++ lib.optionals runTests [
      ps.cl-mock
      ps.fiasco
    ]
  );

  gccLib = "${lib.getLib stdenv.cc.cc}/lib";

  asanOptions = lib.concatStringsSep ":" [
    # SBCL owns these signals
    "handle_segv=0"
    "handle_sigbus=0"
    "handle_sigfpe=0"
    # SBCL wins the fight over sigaltstack, and at thread exit ASan munmaps
    # whatever sigaltstack reports, crashing on addresses it never mapped
    "use_sigaltstack=0"
    # ASan PROT_NONEs the hole between its low and high shadow, and SBCL wants
    # dynamic space at a fixed address inside it, so the gap has to stay open
    "protect_shadow_gap=0"
    # Keeps allocation stacks through the stock libraries below wlroots,
    # which have no frame pointers for the fast unwinder to follow
    "fast_unwind_on_malloc=0"

    # Everything below increases the likelihood and window to catch memory bugs,
    # at the cost of performance, but that's the whole point
    "detect_stack_use_after_return=1"
    "quarantine_size_mb=1024"
    "redzone=64"
    "max_redzone=2048"
    # NOTE(LucasTA): strict_string_checks=1 makes strndup(s, n) crash on X11 strings.
    # They are not null terminated strings and get padded with zeros down to multiples of 4,
    # ASan checks for null termination and reports a false heap-buffer-overflow in a fully filled 4-byte buffer.
    # NOTE(LucasTA): This can become a false positive, if the compositor dies somewhere
    # with "invalid-pointer-pair", lower this to 1 before suspecting a real bug
    "detect_invalid_pointer_pairs=2"
    "check_initialization_order=1"
    "strict_init_order=1"
    "alloc_dealloc_mismatch=1"
    "malloc_context_size=60"
    # NOTE(LucasTA): If quitting the compositor starts hanging or printing
    # pages of lisp-held allocations, remove this
    "detect_leaks=1"
    # This is ASan default, but it's the whole point here, so making it explicit
    "halt_on_error=1"
  ];

  # halt_on_error=0 prevents common wlroots float-divide-by-zero UB from halting
  # mahogany compiles with -fno-sanitize-recover=all, UBSan still halts on it
  ubsanOptions = "print_stacktrace=1:halt_on_error=0:report_error_type=1";

  asanCFlags = lib.concatStringsSep " " [
    "-fsanitize=address"
    "-fno-omit-frame-pointer"
    "-g"
    "-fsanitize=bounds-strict"
    "-fsanitize=float-divide-by-zero"
    "-fsanitize=pointer-compare"
    "-fsanitize=pointer-subtract"
    "-fsanitize-address-use-after-scope"
    # Turns every UBSan check into an abort
    "-fno-sanitize-recover=all"
  ];

  wrapperArgs =
    lib.optionals skipInitFile [
      "--add-flags"
      "-q"
    ]
    ++ lib.optionals sanitize [
      "--set"
      "LD_PRELOAD"
      # so the programs we launch don't carry asan and ubsan
      "${gccLib}/libasan.so ${gccLib}/libubsan.so ${placeholder "out"}/lib/mahogany-asan-unpreload.so"
      "--set"
      "ASAN_OPTIONS"
      asanOptions
      "--set"
      "UBSAN_OPTIONS"
      ubsanOptions
      "--set"
      "ASAN_SYMBOLIZER_PATH"
      "${lib.getBin llvmPackages.llvm}/bin/llvm-symbolizer"
    ];
in
lib.seq checkedArgs (
  stdenv.mkDerivation (
    {
      pname = "mahogany";
      version =
        "0.0.1-unstable-2026-09-11"
        + lib.optionalString (localSrc != null) "-local"
        + lib.optionalString sanitize "-asan";

      src =
        lib.throwIf (localRev != null && localSrc == null)
          "mahogany.nix: localRev needs localSrc, it's a ref inside a git repo"
          (
            if localRev != null then
              fetchGit {
                url = localSrc;
                ref = localRev;
              }
            else if localSrc != null then
              cleanedLocalSrc
            else
              fetchFromGitHub {
                owner = "stumpwm";
                repo = "mahogany";
                inherit rev hash;
              }
          );

      patches = mahoganyPatches;

      prePatch = ''
        rm -rf dependencies/cl-interactive dependencies/cl-xkbcommon
        cp -r --no-preserve=mode,ownership ${cl-interactive} dependencies/cl-interactive
        cp -r --no-preserve=mode,ownership ${cl-xkbcommon} dependencies/cl-xkbcommon
      '';

      nativeBuildInputs = [
        # used for skipInitFile and sanitize wrapProgram
        makeWrapper
        meson
        ninja
        pkg-config
        sbclWithPkgs
        wayland-scanner
      ];

      buildInputs = [
        cairo
        # TODO(LucasTA): declare libdrm in meson.build
        libdrm
        libinput
        libxcb
        # TODO(LucasTA): remove this or add xwayland upstream
        # without libxcb-wm the xwayland option resolves to
        # 'auto' -> off, so no X11 support.
        libxcb-wm
        libxkbcommon
        pango
        pixman
        wayland
        wayland-protocols
        wlroots_0_20
      ];

      env.NIX_CFLAGS_COMPILE =
        "-I${lib.getDev libdrm}/include/libdrm" + lib.optionalString sanitize " ${asanCFlags}";

      postPatch = ''
        substituteInPlace lisp/heart/hrt-libs.lisp \
          --replace-fail '"libheart.so"' '"${placeholder "out"}/lib/libheart.so"' \
          --replace-fail '"libwlroots-0.20.so"' '"${lib.getLib wlroots_0_20}/lib/libwlroots-0.20.so"'

        substituteInPlace dependencies/cl-xkbcommon/xkbcommon.lisp \
          --replace-fail '"libxkbcommon.so.0"' '"${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"'
      '';

      configurePhase = ''
        runHook preConfigure

        # ASDF and uiop want a writable HOME; the sandbox default is not.
        export HOME="$NIX_BUILD_TOP"

        meson setup build/heart heart \
          --prefix=$out \
          --libdir=lib \
          --buildtype=${if sanitize then "debug" else "release"} \
          --wrap-mode=nodownload \
          -Dexample=false \
          -Dwerror=false${lib.optionalString sanitize ''
            \
                 -Db_sanitize=address,undefined -Db_lundef=false -Doptimization=1''}

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild

        ninja -C build/heart

        meson install -C build/heart

        # asdf:make "mahogany/executable" -> build/mahogany
        sbcl --non-interactive --load build-mahogany.lisp

        runHook postBuild
      '';

      doCheck = runTests;

      checkPhase = ''
        runHook preCheck

        sbcl --non-interactive --load run-tests.lisp

        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall

        install -Dm755 build/mahogany $out/bin/mahogany
        ${lib.optionalString (wrapperArgs != [ ]) ''
          wrapProgram $out/bin/mahogany ${lib.escapeShellArgs wrapperArgs}
        ''}

        runHook postInstall
      '';

      dontStrip = true;
      dontPatchELF = true;

      meta = {
        description = "Tiling Wayland compositor written in Common Lisp, in the style of StumpWM";
        homepage = "https://github.com/stumpwm/mahogany";
        license = lib.licenses.gpl2Only;
        mainProgram = "mahogany";
        platforms = lib.platforms.linux;
      };
    }
    // lib.optionalAttrs sanitize {
      hardeningDisable = [
        "fortify"
        "fortify3"
      ];

      # so the programs we launch don't carry asan and ubsan
      postBuild = ''
        cat > unpreload.c <<'CEOF'
        #define _GNU_SOURCE
        #include <stdlib.h>

        __attribute__((constructor)) static void mahogany_asan_unpreload(void) {
          unsetenv("LD_PRELOAD");
          unsetenv("ASAN_OPTIONS");
          unsetenv("UBSAN_OPTIONS");
          unsetenv("ASAN_SYMBOLIZER_PATH");
        }
        CEOF
        $CC -shared -fPIC -O2 -o $out/lib/mahogany-asan-unpreload.so unpreload.c
      '';
    }
  )
)
