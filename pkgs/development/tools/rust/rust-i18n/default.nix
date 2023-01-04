{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-i18n";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-o8/eH0HheMW6rBNzAqN0ghzSTqFiP4y/P5ezVJbIJ3c=";
  };

  cargoSha256 = "sha256-daCO2BlXSPJfipBRNKCTOt5tZrAsRKYbhe6IG9T914M=";

  # The test `test_load` is broken as the required files are not provided in the crate release.
  # The GitHub release is missing the cargo.lock file, so it would require impure evaluation
  checkFlags = "--skip test_load";

  meta = with lib; {
    description = "A crate for loading localized text from a set of YAML mapping files";
    longDescription = ''
      Rust I18n is a crate for loading localized text from a set of YAML mapping
      files. The mappings are converted into data readable by Rust programs at
      compile time, and then localized text can be loaded by simply calling the
      provided t! macro.
    '';
    homepage = "https://github.com/longbridgeapp/rust-i18n";
    changelog = "https://github.com/longbridgeapp/rust-i18n/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bertof ];
  };
}

