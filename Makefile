.PHONY: all deploy

all:
	src/build.sh

dev:
	make all
	cd .build; python3 -m http.server

deploy:
	cd .build; git commit -m "automated deployment ($(shell date | tr '[:upper:]' '[:lower:]'))"; git push
