#!/bin/sh
set -e

root="$(git rev-parse --show-toplevel)"
cache_dir="$root/.cache"
build_dir="$root/.build"
public_dir="$root/public"

mkdir -p "$cache_dir/images"

if [ ! -d "$build_dir" ]; then
	git clone -b netlify git@github.com:caerostris/kenoschwalb.com.git "$build_dir"
fi

echo "Cleaning build directory"
cd "$build_dir"
git rm -rf .
cd ..
rm "$cache_dir/images.css"

echo "Copying development files"
cp -R "$public_dir"/. "$build_dir/"

echo "Precaching images"
"$root/src/precache_images.sh" "$public_dir/index.html" "$cache_dir/images" "$cache_dir/images.css"
cp "$cache_dir/images"/* "$build_dir/static/images/"

echo "Bundling CSS"
rm -r "$build_dir/static/css"
mkdir "$build_dir/static/css"
cat "$public_dir/static/css"/*.css "$cache_dir/images.css" > "$build_dir/static/css/bundle.css"
perl -i -0pe "s/(\s*<link rel='stylesheet' [^>]+>\n)+/\n\t\t<link rel='stylesheet' type='text\/css' href='static\/css\/bundle.css' \/>\n/" "$build_dir/index.html"

cd "$build_dir"
git add --all
git status
