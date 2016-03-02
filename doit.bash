#! /bin/bash
#set -x
# -----------------------------------------------------------------
BASIC_REL_STR=0.0
GITHUB_USER=""
GITHUB_ACCESS_TOKEN=""
REPO_OWNER=""
REPO=REPO=$(basename $PWD)

# ---------
EXAMPLE="example: $0 1.23 -r booking-system -o goeuro -u erwinlottemann"
USAGE="usage: $0 <new basic release string> -r <repository name> -o <respository owner> -u <github user>  optional: -t <github access token>"


#if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
if [ "$#" -lt 1 ] ; then
  echo $USAGE
  echo $EXAMPLE
  exit 1;
fi

while [[ $# > 0 ]] ; do
        printf "\n"
        echo "\$1 = $1"
        
        if [[ "$1" =~ ^-r ]]; then
          echo "-r"
          shift
          REPO=$1
        fi
        if [[ "$1" =~ ^-o ]]; then
          echo "-o"
          shift
          REPO_OWNER=$1
        fi
        if [[ "$1" =~ ^-u ]]; then
          echo "-u"
          shift
          GITHUB_USER=$1
        fi
        if [[ "$1" =~ ^-t ]]; then
          echo "-t"
          shift
          GITHUB_ACCESS_TOKEN=$1
        fi
        #else
        #  echo "no - at beginning"
        #fi
        BASIC_REL_STR=$1
        shift
done



# -----------------------------------------------------------------
#REPO=booking-system
#REPO=$(basename $PWD)
#GITHUB_ACCESS_TOKEN=$(cat ../my_github_access_token)
#if [ ! -f $GITHUB_ACCESS_TOKEN ]; 
#then
#   echo "missing file with github access token "$GITHUB_ACCESS_TOKEN
#   exit 1;
#fi
#REPO_OWNER=dietaschuelter
#REPO_OWNER=goeuro

if [ ! -n "$BASIC_REL_STR" ]; then
    echo "BASIC_REL_STR is empty."
    echo $USAGE
    echo $EXAMPLE
    exit 1;
fi

if [ ! -n "$REPO" ]; then
    echo "REPO is empty."
    echo $USAGE
    echo $EXAMPLE
    exit 1;
fi

if [ ! -n "$REPO_OWNER" ]; then
    echo "REPO_OWNER is empty."
    echo $USAGE
    echo $EXAMPLE
    exit 1;
fi

if [ ! -n "$GITHUB_USER" ]; then
    echo "GITHUB_USER is empty."
    echo $USAGE
    echo $EXAMPLE
    exit 1;
fi
   
echo "REL_STR:     "$BASIC_REL_STR
echo "REPO:        "$REPO
echo "REPO_OWNER:  "$REPO_OWNER
echo "GITHUB_USER: "$GITHUB_USER
 
exit

# -----------------------------------------------------------------
# create branch, create tag
# -----------------------------------------------------------------
#Basic Str:    1.x
#Tag:          1.x.0-rc1    
#Branch:       rel-1.x
#Release-name: Booking Backend 1.x.0

#     BASIC_REL_STR=$1
            REL_TAG=rel-$BASIC_REL_STR.0-rc1
             BRANCH=rel-$BASIC_REL_STR
           REL_NAME="Booking Backend "$BASIC_REL_STR".0"
        DESCRIPTION=""
        
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

#exit -1;

# -----------------------------------------------------------------
git checkout master; git fetch; git pull
git checkout -b $BRANCH
git push origin $BRANCH

git tag $REL_TAG; git push --tag



# -----------------------------------------------------------------



GITHUB_AUTH=${GITHUB_USER}:${GITHUB_ACCESS_TOKEN}
echo $GITHUB_AUTH

API_JSON={\"tag_name\":\"$REL_TAG\",\"target_commitish\":\"master\",\"name\":\"$REL_NAME\",\"body\":\"$DESCRIPTION\",\"draft\":false,\"prerelease\":true}

echo $API_JSON


if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
    echo "GITHUB_ACCESS_TOKEN is empty, so not auth"
    curl -i \
    -d "$API_JSON" \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -X POST \
    "https://api.github.com/repos/$REPO_OWNER/$REPO/releases"
else
  echo "GITHUB_ACCESS_TOKEN: "$GITHUB_ACCESS_TOKEN
    curl -i \
    -d "$API_JSON" \
    -H "Accept: application/json" \
    -H "Content-Type:application/json" \
    -u $GITHUB_AUTH \
    -X POST \
    "https://api.github.com/repos/$REPO_OWNER/$REPO/releases"
fi

#curl -i \
#-d "$API_JSON" \
#-H "Accept: application/json" \
#-H "Content-Type:application/json" \
#-u $GITHUB_AUTH \
#-X POST \
#"https://api.github.com/repos/$REPO_OWNER/$REPO/releases"

# -----------------------------------------------------------------
# list releases of repository
# curl https://api.github.com/repos/$GITHUB_AUTH/code_freeze_test/releases
# -----------------------------------------------------------------
# list releases of repository
# curl https://api.github.com/repos/dietaschuelter/code_freeze_test/releases
#
# basic authentification
# curl -i -u your_username https://api.github.com/users/defunkt
# -----------------------------------------------------------------
#GITHUB_AUTH=$REPO_OWNER" https://api.github.com/users/defunkt"
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
