
echo "\n\n======= Android Section =======\n1 run  \n2 apk  \n3 app bundle  \n4 open apk location \n5 open android bundle location \n\n======= Ios section ======= \n6 build ios   \n7 open ios build folder \n\n ======= anonymous section ======= \n8 refresh cache  \n9 stacked generate \n0 for quit"
read -n 1 my_option

run=1 apk=2 bundle=3 openFolder=4 appBundlelocation=5 iosBuild=6 ioslocation=7  refresh=8 stackeGenerate=9 quit=0

if [ $my_option -eq $run ]
then 
#        dart pub global activate fvm
       fvm flutter run 
elif [ $my_option -eq $apk ]
then 
#        dart pub global activate fvm
       fvm  flutter build apk 
elif [ $my_option -eq $bundle ]
then 
        # dart pub global activate fvm
        fvm flutter build appbundle 
elif [ $my_option -eq $openFolder ]
then 
        open build/app/outputs/bundle/release
elif [ $my_option -eq $refresh ]
then 
        # dart pub global activate fvm
        fvm flutter clean;
        # dart pub global activate fvm
        fvm flutter pub get;

elif [ $my_option -eq $stackeGenerate ]
then 
        stacked generate
elif [ $my_option -eq $iosBuild ]
then 
       sh build_ios.sh
elif [ $my_option -eq $ioslocation ]
then 
        open build/ios/
elif [ $my_option -eq $appBundlelocation ]
then
       open build/app/outputs/bundle/envproductionRelease/

elif [ $my_option -eq $quit ]
then 
       echo "quit"
       clear
else       
        echo "wrong "
fi