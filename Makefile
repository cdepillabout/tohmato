.PHONY: all build reactor release
all: build

elm.js: src/*.elm
	elm-make src/Main.elm

site/js/elm.js: elm.js
	cp elm.js site/js

build: site/js/elm.js

reactor:
	elm-reactor

release: build
	rm -rf /tmp/tohmato-temp-site
	mkdir /tmp/tohmato-temp-site
	git checkout gh-pages
	rm -rf *
	cp /tmp/tohmato-temp-site/* ./
	rm -rf /tmp/tohmato-temp-site
	git add -A .
	git commit -m "Release on `date`."
	git push origin gh-pages
	git checkout master
