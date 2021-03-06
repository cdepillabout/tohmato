.PHONY: all build reactor release test-serve
all: build

elm.js: src/*.elm
	elm-make src/Main.elm

site/js/elm.js: elm.js
	cp elm.js site/js

build: site/js/elm.js

reactor:
	elm-reactor

release: build
	rm -rf /tmp/tohmato-temp-site-update/
	mkdir /tmp/tohmato-temp-site-update/
	cp -r site /tmp/tohmato-temp-site-update/
	cp -r elm-stuff /tmp/tohmato-temp-site-update/
	git checkout gh-pages
	# Remove .gitignore as well because we want to commit the elm.js file,
	# which is being ignored.
	rm -rf * .gitignore
	cp -r /tmp/tohmato-temp-site-update/site/* ./
	git add -A .
	git commit -m "Release on `date`."
	git push origin gh-pages
	git checkout master
	cp -r /tmp/tohmato-temp-site-update/elm-stuff ./
	rm -rf /tmp/tohmato-temp-site-update

test-serve: build
	@echo
	@echo "Your ip address:"
	@ifconfig | egrep -o 'inet addr:[^ ]+' | egrep -o '([0-9]|\.)+' | grep 192
	@echo
	(cd site && python2 -m SimpleHTTPServer 8000)
