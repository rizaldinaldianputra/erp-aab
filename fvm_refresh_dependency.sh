#!/bin/sh

fvm flutter clean
cd shared/dependencies && fvm flutter clean && fvm flutter pub get && cd ../../
cd core && fvm flutter clean && fvm flutter pub get && cd ../
cd shared/component && fvm flutter clean && fvm flutter pub get && cd ../../
cd shared/l10n && fvm flutter clean && fvm flutter pub get && cd ../../
cd shared/preferences && fvm flutter clean && fvm flutter pub get && cd ../../
cd features/apps && fvm flutter clean && fvm flutter pub get && cd ../../
cd features/auth && fvm flutter clean && fvm flutter pub get && cd ../../
cd features/employee && fvm flutter clean && fvm flutter pub get && cd ../../
cd features/employee/attendance && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/home && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/leave && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/notice && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/payroll && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/profile && fvm flutter clean && fvm flutter pub get && cd ../../../
cd features/employee/resign && fvm flutter clean && fvm flutter pub get && cd ../../../
fvm flutter clean && fvm flutter pub get