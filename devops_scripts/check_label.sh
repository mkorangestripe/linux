#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "This script checks that the given label is present"
  echo "for each deployed service in the stack files."
  echo "Usage: ./check_label.sh network_mode"
  exit 1
fi

source stack_file_dirs.sh || exit 1

LABEL="$1"
BASEURL='[REMOVED]'

cmp_deploy_to_label_cnt() {
  ENV=$1
  REGION=$2
  DIRS=$3
  URL=$BASEURL/$ENV/$REGION/_current
  echo "Checking $ENV $REGION..."
  for DIR in $DIRS; do
    STACK_FILE=$(curl -sL $URL/$DIR/$DIR.yml)
    DEPLOY_CNT=$(echo $STACK_FILE | grep -c 'deploy:')
    LABEL_CNT=$(echo $STACK_FILE | grep -c "$LABEL")
    if [ $DEPLOY_CNT -ne $LABEL_CNT ]; then
      echo -e "$DIR \e[1;31m***service found without $LABEL label***\e[00m"
    fi
  done; echo
}

# Comment out any lines below to exclude from checking.
cmp_deploy_to_label_cnt "prod" "amer" "$AMER_PROD_DIRS"
cmp_deploy_to_label_cnt "prod" "emea" "$EMEA_PROD_DIRS"
cmp_deploy_to_label_cnt "prod" "global" "$GLOBAL_PROD_DIRS"

cmp_deploy_to_label_cnt "qe" "amer" "$AMER_QE_DIRS"
cmp_deploy_to_label_cnt "qe" "emea" "$EMEA_QE_DIRS"
cmp_deploy_to_label_cnt "qe" "global" "$GLOBAL_QE_DIRS"

cmp_deploy_to_label_cnt "sit" "amer" "$AMER_SIT_DIRS"
cmp_deploy_to_label_cnt "sit" "emea" "$EMEA_SIT_DIRS"
cmp_deploy_to_label_cnt "sit" "global" "$GLOBAL_SIT_DIRS"

cmp_deploy_to_label_cnt "staging" "amer" "$AMER_STAGING_DIRS"
cmp_deploy_to_label_cnt "staging" "emea" "$EMEA_STAGING_DIRS"
cmp_deploy_to_label_cnt "staging" "global" "$GLOBAL_STAGING_DIRS"
