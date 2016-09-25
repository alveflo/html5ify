PATH := ./node_modules/.bin:${PATH}

.PHONY : all

all : init build

init :
	npm install

build :
	coffee --bare --no-header -o lib/ -c src/
	coffee -o __tests__/ -c tests/
	mkdir __tests__;mkdir __tests__/html;cp tests/html/test.html __tests__/html/test.html
	echo "#!/usr/bin/env node"|cat - ./lib/program.js > /tmp/out && mv /tmp/out ./lib/program.js
	npm test
