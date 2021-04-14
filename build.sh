#!/bin/sh
cd ./src/frontend_mobile
truffle migrate --reset 
flutter pub get
flutter run
