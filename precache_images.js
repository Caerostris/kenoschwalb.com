const fs = require('fs');
const path = require('path');
const https = require('follow-redirects').https;
const cheerio = require('cheerio');

if (process.argv.length < 5) {
	console.error(`Usage: ${process.argv[0]} input_file output_file image_folder [url selectors ...]`);
	process.exit(1);
}

const urlSelectors = process.argv.slice(4);
const inputFile = process.argv[2];
const outputFolder = process.argv[3];
const htmlContents = fs.readFileSync(inputFile, 'utf-8');
const $ = cheerio.load(htmlContents);

$('.tile.image').each(function() {
	const tile = $(this);
	const backgroundImage = tile.css('background-image');
	const matches = backgroundImage.match(/url\(([^\)]+)\)/);
	if (matches.length != 2) {
		return;
	}

	const url = matches[1];
	for (selectorId in urlSelectors) {
		const selector = urlSelectors[selectorId];
		const selectorMatches = url.match(selector);
		if (selectorMatches.length != 2) {
			return;
		}

		const fileId = selectorMatches[1];
		const outputFile = path.join(outputFolder, `${fileId}.jpg`);
		const outStream = fs.createWriteStream(outputFile);

		// rewrite to cached file in HTML tree
		tile.css('background-image', `url(${outputFile})`);

		// cache file at given url
		https.get(url, res => {
			res.pipe(outStream);
			outStream.on('finish', () => outStream.close(() => {
			}));
		}).on('error', err => {
			console.error('Download error:');
			console.error(err);
			process.exit(1);
		});
	}
});

fs.writeFileSync(inputFile, $.html(), 'utf-8');
