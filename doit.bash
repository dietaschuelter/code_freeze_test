#! /bin/bash
set -x

# -----------------------------------------------------------------
BASIC_REL_STR=0.0
ACCESS_TOKEN=./my_github_access_token
#ACCESS_TOKEN=./hugo

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: code_freeze.sh <new basic release string, eg. 1.23>"
  exit 1;
fi

if [ ! -f $ACCESS_TOKEN ]; 
then
   echo "missing file with github access token "$ACCESS_TOKEN
   exit 1;
fi

# -----------------------------------------------------------------

#Basic Str:    1.x
#Tag:          1.x.0-rc1    
#Branch:       rel-1.x
#Release-name: Booking Backend 1.x.0

      BASIC_REL_STR=$1
            REL_TAG=rel-$BASIC_REL_STR.0-rc1
             BRANCH=rel-$BASIC_REL_STR
           REL_NAME="Booking Backend "$BASIC_REL_STR".0"
        DESCRIPTION=""
    

# -----------------------------------------------------------------
# create branch, create tag
# -----------------------------------------------------------------
#echo 
#echo "release string: "$BASIC_REL_STR
#echo "release tag:    "$REL_TAG
#echo "branch:         "$BRANCH
#echo 

if [ ! -n "$BASIC_REL_STR" ]; then
    echo "BASIC_REL_STR is empty."
    exit 1;
fi

if [ ! -n "$REL_TAG" ]; then
    echo "REL_TAG is empty."
    exit 1;
fi

if [ ! -n "$BRANCH" ]; then
    echo "BRANCH is empty."
    exit 1;
fi

git checkout master; git fetch; git pull
git checkout -b $BRANCH; git branch $BRANCH
git push origin $BRANCH

git tag $REL_TAG; git push --tag



# -----------------------------------------------------------------
#REPOSITORY=booking-system
REPOSITORY=code_freeze_test
ACCESS_TOKEN=$(cat ./my_github_access_token)
OWNER=dietaschuelter

if [ ! -n "$REPOSITORY" ]; then
    echo "REPOSITORY is empty."
    exit 1;
fi
if [ ! -n "$ACCESS_TOKEN" ]; then
    echo "ACCESS_TOKEN is empty."
    exit 1;
fi
if [ ! -n "$OWNER" ]; then
    echo "OWNER is empty."
    exit 1;
fi

# -----------------------------------------------------------------
# list releases of repository
# curl https://api.github.com/repos/dietaschuelter/code_freeze_test/releases
#USER="\"$OWNER:$ACCESS_TOKEN\""
USER=${OWNER}:${ACCESS_TOKEN}
echo $USER

#API_JSON=$(printf '{"tag_name":"%s","target_commitish":"master","name":"%s","body":"%s","draft":false,"prerelease":true}' $REL_TAG $REL_NAME $DESCRIPTION)

API_JSON={\"tag_name\":\"$REL_TAG\",\"target_commitish\":\"master\",\"name\":\"$REL_NAME\",\"body\":\"$DESCRIPTION\",\"draft\":false,\"prerelease\":true}

#{\"tag_name\":\"$REL_TAG\",\"target_commitish\":\"master\",\"name\":\"$REL_NAME\",\"body\":\"$DESCRIPTION\",\"draft\":false,\"prerelease\":true}

echo $API_JSON



curl -i \
-d "$API_JSON" \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-u "$USER" \
-X POST \
"https://api.github.com/repos/dietaschuelter/code_freeze_test/releases"

#-H "\"Accept: application/json\"" \
#-H "\"Content-Type:application/json\"" \

#curl -i \
#--data \'$API_JSON\' \
#-H "\"Accept: application/json\"" \
#-H "\"Content-Type:application/json\"" \
#-u "$USER" \
#-X POST \
#"https://api.github.com/repos/dietaschuelter/code_freeze_test/releases"

#--data \'$API_JSON\' \
# this one works
#echo curl -H "\"Accept: application/json\"" -H "\"Content-Type: application/json\"" --request POST https://api.github.com/repos/dietaschuelter/code_freeze_test/releases -u "\"dietaschuelter:941e6cce9130bfd6eeec9f316582cd4b7c91e271\"" -d \''{"tag_name":"rel-2.00.0-rc1","target_commitish":"master","name":"Booking Backend 2.00.0","body":"DESCRIPTION","draft": false,"prerelease":true}'\'


# -----------------------------------------------------------------
#  name	            Type	          Description
#  tag_name	        string	Required. The name of the tag.
#  target_commitish	string	Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Unused if the Git tag already exists. Default: the repository's default branch (usually master).
#  name	            string	          The name of the release.
#  body	            string	          Text describing the contents of the tag.
#  draft	        boolean	          true to create a draft (unpublished) release, false to create a published one. Default: false
#  prerelease	    boolean	          true to identify the release as a prerelease. false to identify the release as a full release. Default: false
#  
#  
#  {
#    "tag_name": "v1.0.0",
#    "target_commitish": "master",
#    "name": "v1.0.0",
#    "body": "Description of the release",
#    "draft": false,
#    "prerelease": false
#  }
# -----------------------------------------------------------------
#API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "%s","body": "%s","draft": false,"prerelease": true}' $REL_TAG "$REL_NAME" $DESCRIPTION)
#echo $API_JSON

#--data \''{"tag_name":"'"$REL_TAG"'","target_commitish":"master","name":"'"$REL_NAME"'","body":"'"$DESCRIPTION"'","draft":false,"prerelease":true}'\' \