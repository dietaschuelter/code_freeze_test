#! /bin/bash

BASIC_REL_STR=0.0

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: code_freeze.sh <new basic release string, eg. 1.23>"
  exit 1;
fi

#Basic Str:    1.x
#Tag:          1.x.0-rc1    
#Branch:       rel-1.x
#Release-name: Booking Backend 1.x.0

BASIC_REL_STR=$1
      REL_TAG=rel_$BASIC_REL_STR.0-rc1
       BRANCH=rel-$BASIC_REL_STR

# REMOTE_REPOSITORY=git@github.com:dietaschuelter/code_freeze_test
# REL_TAG=rel_$BASIC_REL_STR.0
# BRANCH=branch_$BASIC_REL_STR

echo 
echo "release string: "$BASIC_REL_STR
echo "release tag:    "$REL_TAG
echo "branch:         "$BRANCH
echo 

 git checkout master; git fetch; git pull
 git checkout -b $BRANCH; git branch $BRANCH
 git push origin $BRANCH

 git tag $REL_TAG; git push --tag
