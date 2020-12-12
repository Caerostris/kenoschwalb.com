# kenoschwalb.com

This repository contains the source code of my personal website.

## Tech Stuff

Hosting is provided by Netlify with automatic deployments on push to the `netlify` branch.  
I'd prefer to use GitHub Pages but they won't let me set HTTP headers like HSTS and CSP.  
Source code can be found in the `main` branch.

The website is a single-page application consisiting of just HTML5 and CSS. Nothing fancy there.

## Build and Deployment

Run `make` in order to build the site.  
This will start a shell script which fetches a few thumbnails from Instagram and bundles the CSS code.  
The output is written to the `netlify` branch but not commited.

Run `make deploy` in order commit and publish the changes.
