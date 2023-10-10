#!/bin/bash

echo "Starting nginx..."
exec $(which nginx) -g "daemon off;"
