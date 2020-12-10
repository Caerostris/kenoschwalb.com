.PHONY: all deploy

all:
	src/build.sh

deploy:
	cd .build; git commit -m "automated build ($(shell date | tr '[:upper:]' '[:lower:]'))"; git push
