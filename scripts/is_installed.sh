#!/bin/bash

which "${1}" | grep -o "${1}" > /dev/null && exit 0 || exit 1
