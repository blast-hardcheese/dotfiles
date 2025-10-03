{ pkgs ? import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/5b5be50345d4113d04ba58c444348849f5585b4a.tar.gz";
  sha256 = "";
}) {}
}:

with pkgs;

buildGo124Module rec {
  pname = "crd-wizard";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "pehlicd";
    repo = "crd-wizard";
    tag = "v${version}";
    hash = "sha256-yJzL1VIfopJY289QOqrKfSqgcZ/8hHyq9IkfqG8QbTs=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  vendorHash = "sha256-5nWXMtcSdWLJg5l1iGNY0XfvWHYXogwl+kSFLh8azoo=";

  env.CGO_ENABLED = 1;

# preConfigure = ''
#   ldflags="-s -w -X github.com/abiosoft/colima/config.appVersion=${version} \
#   -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
# '';

# passthru.tests.version = testers.testVersion {
#   package = colima;
#   command = "HOME=$(mktemp -d) colima version";
# };

  meta = with lib; {
    description = "Quickly understand the state of their custom controllers and the resources they manage.";
    homepage = "https://github.com/pehlicd/crd-wizard";
    license = licenses.gpl3;
    maintainers = with maintainers; [
    ];
    mainProgram = "crd-wizard";
  };
}
