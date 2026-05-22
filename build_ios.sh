dart pub global activate fvm
fvm flutter clean;
cd ios
pod deintegrate
rm podfile.lock
rm -r .symlinks

cd ..
dart pub global activate fvm
fvm flutter pub get;

cd ios
pod install
pod update

cd ..

# fvm flutter build ipa
fvm flutter run;