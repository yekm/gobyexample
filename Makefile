.PHONY: goimports clean-bdeps clean travis gh-pages

%.html: %.go
	echo "processing $< to $@"
	mkdir -p tmp/$<
	bash tools/gobyline.sh $< tmp/$<
	./maketable $< tmp/$< site/example.html >$@

src = $(wildcard examples/*.go)
html = $(src:.go=.html)
#export = $(html:examples/=e/)


all:
	$(MAKE) utils
	$(MAKE) pages
	cp site/main.css build/
	$(MAKE) clean-bdeps

utils: maketable goimports

maketable:
	go build tools/maketable.go

goimports:
	go get golang.org/x/tools/cmd/goimports

pages: $(html)
	mkdir build || true
	cp -f $^ build/
	bash tools/gen-index.sh $^
	mv index.html build

clean-bdeps:
	rm -r tmp maketable $(html) || true

clean: clean-bdeps
	rm -rv build || true

gh-pages:
	git branch -D gh-pages || true
	git checkout --orphan gh-pages
	mv -f build/index.html .
	rm -r e || true
	mv -v build e
	git reset
	git add -f index.html e
	git commit -am "gh-pages update from makefile ${TRAVIS_BUILD_NUMBER} ${TRAVIS_COMMIT}"
	git remote add ghp 'git@github.com:yekm/gobyexample.git'
	git push -uf ghp gh-pages

travis:
	git config user.email "travis@travis-ci.org"
	git config user.name "Travis CI"
	echo "${DKEY}" | base64 -d >dkey
	chmod u=r,go= dkey
	echo 'ssh -i dkey -o "StrictHostKeyChecking no" $$@' >ssh.sh
	chmod +x ssh.sh
	GIT_SSH=./ssh.sh $(MAKE) gh-pages
