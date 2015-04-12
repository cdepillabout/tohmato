.PHONY: all build reactor release
all: build

elm.js: src/Main.elm
	elm-make src/Main.elm

site/js/elm.js: elm.js
	cp elm.js site/js

build: site/js/elm.js

reactor:
	elm-reactor

release: build
	# copy files to server
