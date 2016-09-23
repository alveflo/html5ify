PATH := ./node_modules/.bin:${PATH}

.PHONY : all

all : init build

init :
	npm install

build :
	coffee --bare --no-header -o lib/ -c src/ 
	npm test
