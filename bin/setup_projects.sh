#!/bin/bash
# Create Homework Projects with GUID prefix.
# When FROM_JENKINS=true then project ownership is set to USER
# Set FROM_JENKINS=false for testing outside of the Grading Jenkins
if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "  $0 GUID USER FROM_JENKINS"
    exit 1
fi

GUID=$1
USER=$2
FROM_JENKINS=$3

#oc login https://master.na311.openshift.opentlc.com:443 --token=fjtan4wiNz1MoM2hhrEzkoFwTSB2F_TRDFVnXF6hqTE --insecure-skip-tls-verify

oc login https://master.na311.openshift.opentlc.com:443 --token=1C1cKtwhJECKqgmiz1f8Wdy1MwYkMHJTs6UEAc1GiNY --insecure-skip-tls-verify

echo "Creating Homework Projects for GUID=${GUID} and USER=${USER}"
oc new-project ${GUID}-jenkins    --display-name="${GUID} AdvDev Homework Jenkins"
oc new-project ${GUID}-tasks-dev  --display-name="${GUID} AdvDev Homework Tasks Development"
oc new-project ${GUID}-tasks-prod --display-name="${GUID} AdvDev Homework Tasks Production"

if [ "$FROM_JENKINS" = "true" ]; then
  oc adm policy add-role-to-user admin ${USER} -n ${GUID}-jenkins
  oc adm policy add-role-to-user admin ${USER} -n ${GUID}-tasks-dev
  oc adm policy add-role-to-user admin ${USER} -n ${GUID}-tasks-prod

#  oc annotate namespace ${GUID}-jenkins    openshift.io/requester=${USER} --overwrite
#  oc annotate namespace ${GUID}-tasks-dev  openshift.io/requester=${USER} --overwrite
#  oc annotate namespace ${GUID}-tasks-prod openshift.io/requester=${USER} --overwrite
fi
