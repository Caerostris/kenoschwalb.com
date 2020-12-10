#!/bin/sh

if [ -z "$3" ]; then
	echo "usage: $0 <HTML input file> <image output directory> <css output file>"
	exit 1
fi

input_file="$1"
image_cache_folder="$2"
css_output_file="$3"

positions="
	instagram-image-t-l
	instagram-image-t-m
	instagram-image-t-r
	instagram-image-m-l
	instagram-image-m-r
	instagram-image-b-l
	instagram-image-b-m
	instagram-image-b-r"

for position in $positions; do
	image_id="$(xmllint --html --xpath "//div[@id='$position']/a/@href" "$input_file" 2>/dev/null | cut -d '"' -f 2 | cut -d '/' -f 5)"
	output_file_name="instagram_$image_id.jpg"
	output_file="$image_cache_folder/$output_file_name"
	
	echo -n "$output_file"
	echo "#$position { background-image: url(/static/images/$output_file_name); }" >> "$css_output_file"

	if [ -f "$output_file" ]; then
		echo " (cached)"
		continue
	fi

	download_url="$(curl -Ls "https://www.instagram.com/p/$image_id/" | grep -o "{\"src\":[^}]*}" | head -n 1 | jq -r .src)"
	curl -Ls "$download_url" -o "$output_file"
	echo " (fetch)"
done


