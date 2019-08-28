# Go by Example

Content and build toolchain for [Go by Example](https://yekm.github.io/gobyexample),
a site that teaches Go via annotated example programs.

### Overview

The Go by Example site is built by extracting code and
comments from source files in `examples` and rendering
them via the `templates` into a static `public`
directory. The programs implementing this build process
are in `tools`.

### Building

[![Build Status](https://travis-ci.com/yekm/gobyexample.svg?branch=master)](https://travis-ci.com/yekm/gobyexample)
 
See `Makefile`

### Publishing

Travis pushes to gh-pages. Set `DKEY` env var in travis
settings to a base64 encoded content of your deploy key.

### Forking

Remove or edit google analytics id

### TODO

- [ ] prettify index.html
- [ ] add link to github for every example
- [ ] add usual full example output below the table
- [ ] write script to pull examples from upstream and trigger it from travis
- [ ] post examples to play.golang.org via curl in Makefile and then sed s/%SOMETIHNG%/play.golang.url/ in  corresponding html file
- [ ] debug strange behaviour like in command-line-flags.html
- [ ] parse markdown in comments with some js library from cdn like Marked.js
- [ ] move to pure.css and divs

### License

This work is copyright Mark McGranaghan and licensed under a
[Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).

The Go Gopher is copyright [Renée French](http://reneefrench.blogspot.com/) and licensed under a
[Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).

### Thanks

Thanks to [Jeremy Ashkenas](https://github.com/jashkenas)
for [Docco](http://jashkenas.github.com/docco/), which
inspired this project.
