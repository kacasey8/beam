#!/bin/bash
echo "rm built.zip"
rm built.zip
echo "grunt"
grunt
echo "rm -rf built/client"
rm -rf built/client
echo "mv dist built/client"
mv dist built/client
echo "zip -r built.zip built"
zip -r built.zip built
