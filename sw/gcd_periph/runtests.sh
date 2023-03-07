#!/bin/bash
make --no-print-directory -C hw clean main
make --no-print-directory -C sw clean main

echo ""
cat gcd.h | tail -n 2
echo ""

hw=$(command time -f '%e' make --no-print-directory -C hw real 2>hw_time | head -n 5 | tail -n 2)
hw_time=$(cat hw_time | tail -n 1)
sw=$(command time -f '%e' make --no-print-directory -C sw real 2>sw_time | head -n 5 | tail -n 2)
sw_time=$(cat sw_time | tail -n 1)

echo "HW result:"
echo -e "\t$hw"
echo -e "\t$hw_time s"
echo "SW result:"
echo -e "\t$sw"
echo -e "\t$sw_time s"


rm hw_time sw_time
