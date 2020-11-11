#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "This script checks that the given label is present"
  echo "for each deployed service in the stack files."
  echo "Usage: ./check_label.sh network_mode"
  exit 1
fi

ENVS='sit qe staging prod'
REGIONS='amer emea global'
BASEURL='[REMOVED]'
STACK_FILES_BROWSE_URL="$BASEURL/service/rest/repository/browse/stack-files"
GROUP_LIST_FILE='stack_file_groups'
LABEL="$1"

get_stack_file_groups() {
  echo "Updating $GROUP_LIST_FILE"
  echo -e "# $STACK_FILES_BROWSE_URL\n" > $GROUP_LIST_FILE
  echo "LAST_UPDATED=$(date +%F)" >> $GROUP_LIST_FILE
  echo >> $GROUP_LIST_FILE
  for ENV in $ENVS; do
    for REGION in $REGIONS; do
      echo "${REGION^^}_${ENV^^}='" >> $GROUP_LIST_FILE
      URL="$STACK_FILES_BROWSE_URL/$ENV/$REGION/_current/"
      curl -sL "$URL" | grep -v "Parent Directory" | awk -F\" '/<td><a href=/{print $2}' | tr -d / >> $GROUP_LIST_FILE
      echo -e "'\n" >> $GROUP_LIST_FILE
    done
  done
}

cmp_deploy_to_label_cnt() {
  ENV=$1
  REGION=$2
  SERVICES=$3
  URL="$BASEURL/repository/stack-files/$ENV/$REGION/_current"
  echo "Checking $ENV $REGION..."
  for SERVICE in $SERVICES; do
    STACK_FILE=$(curl -sL "$URL/$SERVICE/$SERVICE.yml")
    DEPLOY_CNT=$(echo "$STACK_FILE" | grep -c 'deploy:')
    LABEL_CNT=$(echo "$STACK_FILE" | grep -c "$LABEL")
    if [ "$DEPLOY_CNT" -ne "$LABEL_CNT" ]; then
      echo -e "$SERVICE \e[1;31m***service found without $LABEL label***\e[00m"
    fi
  done; echo
}

get_stack_file_groups # Comment out to prevent updating GROUP_LIST_FILE

source $GROUP_LIST_FILE || exit
echo -e "$GROUP_LIST_FILE last updated $LAST_UPDATED\n"

# Comment out any lines below to exclude from checking.
cmp_deploy_to_label_cnt "sit" "amer" "$AMER_SIT"
cmp_deploy_to_label_cnt "sit" "emea" "$EMEA_SIT"
cmp_deploy_to_label_cnt "sit" "global" "$GLOBAL_SIT"

cmp_deploy_to_label_cnt "qe" "amer" "$AMER_QE"
cmp_deploy_to_label_cnt "qe" "emea" "$EMEA_QE"
cmp_deploy_to_label_cnt "qe" "global" "$GLOBAL_QE"

cmp_deploy_to_label_cnt "staging" "amer" "$AMER_STAGING"
cmp_deploy_to_label_cnt "staging" "emea" "$EMEA_STAGING"
cmp_deploy_to_label_cnt "staging" "global" "$GLOBAL_STAGING"

cmp_deploy_to_label_cnt "prod" "amer" "$AMER_PROD"
cmp_deploy_to_label_cnt "prod" "emea" "$EMEA_PROD"
cmp_deploy_to_label_cnt "prod" "global" "$GLOBAL_PROD"
