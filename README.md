Rboggle [![Build Status](https://travis-ci.org/soundasleep/rboggle.svg?branch=master)](https://travis-ci.org/soundasleep/rboggle) [![Code Climate](https://codeclimate.com/github/soundasleep/rboggle/badges/gpa.svg)](https://codeclimate.com/github/soundasleep/rboggle) [![Test Coverage](https://codeclimate.com/github/soundasleep/rboggle/badges/coverage.svg)](https://codeclimate.com/github/soundasleep/rboggle/coverage)
=======

A multiplayer open source implementation of Boggle in Ruby on Rails.

## Dictionary

The dictionaries used are the English and English (GB) dictionaries,
with the first set of acceptable variants, obtainable from http://wordlist.aspell.net/scowl-readme/.
This is because not all operating systems have dictionaries, and often these dictionaries
do not provide plural versions.

These can be browsed in [dict/](dict/) and updated as necessary.
At last count there were approximately ~244,000 words.
