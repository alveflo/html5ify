PATH := ./node_modules/.bin:${PATH}

.PHONY : all

all : init build

init :
	npm install

build :
	coffee --bare --no-header -o lib/ -c src/
	echo "#!/usr/bin/env node"|cat - ./lib/program.js > /tmp/out && mv /tmp/out ./lib/program.js
	npm test
