Rboggle [![Build Status](https://travis-ci.org/soundasleep/rboggle.svg?branch=master)](https://travis-ci.org/soundasleep/rboggle) [![Code Climate](https://codeclimate.com/github/soundasleep/rboggle/badges/gpa.svg)](https://codeclimate.com/github/soundasleep/rboggle) [![Test Coverage](https://codeclimate.com/github/soundasleep/rboggle/badges/coverage.svg)](https://codeclimate.com/github/soundasleep/rboggle/coverage)
=======

A multiplayer open source implementation of Boggle in Ruby on Rails.

## Installing

Copy `.env.sample` to `.env` and update as necessary, particularly your [Google OAuth2 parameters](http://jevon.org/wiki/Google_OAuth2_with_Ruby_on_Rails).

```
bundle
rake db:setup
rails s
guard
```

On Windows, use `bundle install --without production`.

## Dictionary

The dictionaries used are the English and English (GB) dictionaries,
with the first set of acceptable variants, obtainable from http://wordlist.aspell.net/scowl-readme/.
This is because not all operating systems have dictionaries, and often these dictionaries
do not provide plural versions.

These can be browsed in [dict/](dict/) and updated as necessary.
At last count there were approximately ~243,000 words.

Load the dictionary with `rake db:setup`.
