#!/bin/sh
set -e

cd Regexer

pod install

xctool -workspace Regexer.xcworkspace -scheme Regexer.iOS test
xctool -workspace Regexer.xcworkspace -scheme Regexer.Mac test