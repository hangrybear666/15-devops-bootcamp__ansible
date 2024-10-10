#!/bin/bash

# replace HOST in index.html with target server's public IP
sed -i "s/const HOST = \"my-java-app.com\";/const HOST = \"$1\";/" java-app/src/main/resources/static/index.html
echo "-----" && echo "replaced HOST in java-app/src/main/resources/static/index.html" && echo "-----"
