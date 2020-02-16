# packages.gentoo.org (kkuleomi)
 
This is the code that powers [packages.gentoo.org](https://packages.gentoo.org/),
internally codenamed kkuleomi/꾸러미 which is Korean for package (who would have thought!)

## Build status

[![Travis-CI Build Status](https://travis-ci.org/gentoo/gpackages.svg?branch=master)](https://travis-ci.org/gentoo/gpackages)

## Installation instructions

```shell script
 $ docker build -t gentoo/rails:latest .docker/gentoo-rails
 $ docker build -t gentoo/gpackages:latest .
 $ docker-compose up  
```

If you don't use containers, please make sure that 'yarnpkg' is in your path. 

## Configuration

`ELASTICSEARCH_URL` is where the app thinks ES lives; defaults to `localhost:9200`.
`REDIS_URL` is the URL where sidekiq looks for redis; defaults to `localhost:6379`.

Configure `config/secrets.yml`.

## How to submit new contributions

Email [gpackages@gentoo.org](mailto:gpackages@gentoo.org) or
file a bug on [bugs.gentoo.org](https://bugs.gentoo.org/) (Websites → Packages).

## Contributors / Copyright Holders
* 2016 [Alex Legler (a3li)](mailto:a3li@gentoo.org)
* 2017-2019 [Robin H. Johnson (robbat2)](mailto:robbat2@gentoo.org)
* 2018-2019 [Alec Warner (antarus)](mailto:antarus@gentoo.org)
* 2019 [Hans de Graaff (graaff)](mailto:graaff@gentoo.org)
* 2019 [Max Magorsch](mailto:max@magorsch.de)

## History

Kkuleomi is at least the fifth rewrite of packages.gentoo.org.
Some of the rewrites were complete flops, and never went public.

### 2016-present: 'kkuleomi'
* https://gitweb.gentoo.org/sites/packages.git/
* Ruby on Rails
* ElasticSearch backend.
* Authors:
   * [Alex Legler (a3li)](mailto:a3li@gentoo.org)
* Contributors:
   * (see above)

### 2012: 'gentoo-packages' (never deployed)
* https://gitweb.gentoo.org/proj/gentoo-packages.git/
* Never launched
* GSOC2012 rewrite
* Python & Django
* Authors:
   * [Slava Bacherikov](mailto:)

### 2007-2015:
* https://gitweb.gentoo.org/packages.git/
* Runs in production, 2007-2015.
* Python, CherryPy & Genshi
* MySQL backend
* Authors:
   * [Markus Ullmann (jokey)](mailto:jokey@gentoo.org) (2007)
   * [Robin H. Johnson (robbat2)](mailto:robbat2@gentoo.org) (2007-)
* Contributors:
   * [Alec Warner (antarus)](mailto:antarus@gentoo.org)
   * [Christian Ruppert (idl0r)](mailto:idl0r@gentoo.org)
   * [John Klehm](mailto:xixsimplicityxix@gmail.com)
   * [Pavlos Ratis (dastergon)](mailto:dastergon@gentoo.org)

### 2005-2007: 'P2' (never deployed)
* https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/packages/?pathrev=pre_2-0
* CVS branch `pre_2-0`
* Never launched.
* Python, Quixote (http://www.mems-exchange.org/software/quixote/)
* MySQL backend
* Authors:
   * [Albert Hopkins (marduk)](mailto:marduk@gentoo.org)
* Contributors: (unknown)

### 2004-2007
* https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/packages/
* first known `packages.gentoo.org` codebase
* Runs in production 2004 - mid-2007.
* Generate static HTML with use of server-side includes.
* Python, no framework.
* MySQL backend
* Authors:
   * [Albert Hopkins (marduk)](mailto:marduk@gentoo.org)
* Contributors: (unknown)
