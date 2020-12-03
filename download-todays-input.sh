#!/bin/bash

# put the session in bashrc `export AOC_SESSION="..."`
day=$(date +"%-d")
curl --silent --show-error --cookie "session=$AOC_SESSION" \
  --output "./inputs/day${day}" \
  "https://adventofcode.com/2020/day/${day}/input"
