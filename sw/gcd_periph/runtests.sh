#!/bin/bash

make -C hw clean main
make -C sw clean main

time make -C hw real
time make -C sw real
