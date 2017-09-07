#!/bin/bash


# Iconizer shell script by Stefan Herold

# This is a simple tool to generate all necessary app icon sizes from one vector file.
# To use: specify the path to your vector graphic (PDF format)
# Example: sh iconizer.sh MyVectorGraphic.pdf

# Requires ImageMagick: http://www.imagemagick.org/
# Requires jq: https://stedolan.github.io/jq/

# set -e
# set -x

if [ $# -ne 1 ]
  then
        echo "Usage: $0 <version>"
else
    echo "Triggering CI to build product..."

    curl https://www.bitrise.io/app/d4f39dc6286bb63a/build/start.json --data '{"hook_info":{"type":"bitrise","api_token":"Jx56IDVv9IaM83x6GE7hsw"},"build_params":{"branch":"develop","commit_message":"Release Version '$(echo $1)'","workflow_id":"release","environments":[{"mapped_to":"RELEASING_GIT_TAG","value":"'$(echo $1)'","is_expand":true}]},"triggered_by":"curl"}'
fi