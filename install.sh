#!/bin/bash

command -v chuck >/dev/null 2>&1 || { echo >&2 "I require chuck but it's not installed.  Aborting."; exit 1; }
command -v ruby >/dev/null 2>&1 || { echo >&2 "I require ruby but it's not installed.  Aborting."; exit 1; }
command -v gem >/dev/null 2>&1 || { echo >&2 "I require gem but it's not installed.  Aborting."; exit 1; }
command -v bundle >/dev/null 2>&1 && { gem install bundler; cd ruby; bundle install; }
