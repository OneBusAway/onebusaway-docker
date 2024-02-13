#!/bin/bash

# Your custom commands here
echo "ABXOXO Running custom startup commands..."

# Now call the parent image's CMD
exec catalina.sh run
