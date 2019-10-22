#!/bin/bash

DIFF=$(diff <(head -n 1 results.txt) <(head -n 1 base.txt))
WANNA_EXIT=cool

if [ "$DIFF" != "" ]
then
  echo "ERROR website html does not match or website does not exist"
  exit 1;
fi

echo "webpage looks good!"

DIFF=$(diff <(head -n 10 results.txt | tail -n $((10-5+1))) <(head -n 10 base.txt | tail -n $((10-5+1))))

if [ "$DIFF" != "" ]
then
  echo "ERROR something is wrong with your port scan"
  exit 1;
fi

if [ "$WANNA_EXIT" == "coo" ]
then
  echo "exit cool"
  exit 1;
fi

echo "this is the end"

echo "ports look good!"