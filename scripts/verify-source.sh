#!/bin/sh

set -eu

expected_hash='689208a48dcb55309b099165f78f4190debdecfcde7f27005b45a7591b4f9fc7'
expected_lines='693'
expected_bytes='173993'

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/救猫咪三部曲.md" >&2
  exit 2
fi

source_file=$1

if [ ! -f "$source_file" ]; then
  echo "source not found: $source_file" >&2
  exit 2
fi

actual_hash=$(shasum -a 256 "$source_file" | awk '{print $1}')
actual_lines=$(wc -l < "$source_file" | tr -d ' ')
actual_bytes=$(wc -c < "$source_file" | tr -d ' ')

if [ "$actual_hash" != "$expected_hash" ] || [ "$actual_lines" != "$expected_lines" ] || [ "$actual_bytes" != "$expected_bytes" ]; then
  echo "source differs from the recorded baseline" >&2
  echo "hash:  $actual_hash" >&2
  echo "lines: $actual_lines" >&2
  echo "bytes: $actual_bytes" >&2
  exit 1
fi

echo "source matches recorded baseline"
