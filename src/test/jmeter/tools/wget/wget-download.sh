#!/bin/bash
wget -S --limit-rate=20m --progress=dot:mega --output-document=- $1 | head -c 1000