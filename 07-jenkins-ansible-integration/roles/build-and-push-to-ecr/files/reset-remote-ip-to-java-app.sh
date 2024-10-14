#!/bin/bash

# reset HOST in index.html with original value
sed -i "s/const HOST = \"$1\";/const HOST = \"my-java-app.com\";/" ./java-app/src/main/resources/static/index.html
echo "reset HOST in ./java-app/src/main/resources/static/index.html to:"
sed -n 48p java-app/src/main/resources/static/index.html
