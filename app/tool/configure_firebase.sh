dart pub global activate flutterfire_cli

flutterfire configure \
  --yes \
  --project=mek-gasol \
  --out=lib/packages/firebase_options.dart \
  --platforms=web,macos,ios,android \
  --macos-bundle-id=mek.gasol.mekGasol \
  --ios-bundle-id=mek.gasol.mekGasol \
  --android-package-name=mek.gasol.mek_gasol
