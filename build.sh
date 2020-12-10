#!/bin/sh
set -e

mkdir -p .cache/images

echo "Cleaning build directory"
rm -rf build/*
mkdir -p build

echo "Copying development files"
cp index.html build/
cp keybase.txt build/
cp -R static build
rm -r build/static/css
mkdir build/static/css

echo "Precaching images"
./precache_images.sh index.html .cache/images .cache/images.css
cp .cache/images/* build/static/images/

echo "Minifying CSS"
node_modules/clean-css-cli/bin/cleancss --source-map -o build/static/css/main.min.css .cache/images.css static/css/*.css
perl -i -0pe "s/(\s*<link rel='stylesheet' [^>]+>\n)+/\n\t\t<link rel='stylesheet' type='text\/css' href='static\/css\/main.min.css' \/>\n/" build/index.html
