dart pub global activate flutterfire_cli

flutterfire configure \
  --project=mek-gasol \
  --out=lib/packages/firebase_options.dart \
  --platforms=web,macos,android \
  --macos-bundle-id=mek.gasol.mekGasol \
  --android-package-name=mek.gasol.mek_gasol
