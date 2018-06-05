#!/bin/sh
set -e

rm -rf build
mkdir build
cp index.html build/
cp -R static build && rm build/static/css/*.css
cat \
	static/css/main.css \
	static/css/layout.css \
	static/css/home.css \
	static/css/fencer.css \
	static/css/photographer.css \
	static/css/student.css \
	| node_modules/csso-cli/bin/csso > build/static/css/main.min.css
perl -i -0pe "s/(\s*<link rel='stylesheet' [^>]+>\n)+/\n\t\t<link rel='stylesheet' type='text\/css' href='static\/css\/main.min.css' \/>\n/" build/index.html
mkdir build/static/images/thumbnails
cd build
node ../precache_images.js index.html static/images/thumbnails "https://www.instagram.com/p/([^/]+)/media"
