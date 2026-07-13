{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  libdrm,
  pciutils,
  python3,
  systemd,
  umr,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bc250-cu-live-manager";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "WinnieLV";
    repo = "bc250-cu-live-manager";
    rev = "main";
    hash = "sha256-x//BTB7CdqZyoR4+Hjr3bZcmLk20SCE/9txhGBDUnuE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bc250-cu-live-manager.sh \
      "$out/bin/bc250-cu-live-manager"

    patchShebangs "$out/bin/bc250-cu-live-manager"

    substituteInPlace "$out/bin/bc250-cu-live-manager" \
      --replace-fail 'for p in /usr/bin/umr /usr/local/bin/umr /opt/umr/build/src/app/umr; do' \
        'for p in ${lib.getExe' umr "umr"} /usr/bin/umr /usr/local/bin/umr /opt/umr/build/src/app/umr; do' \
      --replace-fail '/usr/bin/bash' '${lib.getExe bash}'

    wrapProgram "$out/bin/bc250-cu-live-manager" \
      --prefix PATH : ${lib.makeBinPath [
        bash
        coreutils
        gawk
        gnugrep
        gnused
        pciutils
        python3
        systemd
        umr
      ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdrm ]}

    runHook postInstall
  '';

  meta = {
    description = "Interactive WGP and CU dispatch control for AMD BC-250 using UMR";
    homepage = "https://github.com/WinnieLV/bc250-cu-live-manager";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "bc250-cu-live-manager";
  };
}
