#!/bin/zsh

# Generates localized strings for all swift files in the main project directory
# and writes them to each locale's `Localizable.strings` file.


cd StoreSearch

find ./ -name "*.swift" -print0 | xargs -0 xcrun extractLocStrings -o en.lproj
# xcodebuild -exportLocalizations -project StoreSearch.xcodeproj -localizationPath ./Resources/Localization/
