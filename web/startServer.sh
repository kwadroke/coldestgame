#!/bin/bash

export HOME=/tmp
cd $1
$2 > /dev/null 2>&1 &
echo $!