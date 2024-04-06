#!/usr/bin/env bash

echo "Using poetry at: $(which poetry)"

source $(poetry env info -p)/bin/activate
