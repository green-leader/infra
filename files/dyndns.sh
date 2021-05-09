#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

DOMAIN="vpn.sions.org."
MANAGEDZONE="org-sions-vpn"
EXISTING=$(gcloud dns record-sets list --zone="$MANAGEDZONE" --type="A" --name="$DOMAIN" | grep "$DOMAIN" | awk '{print $4}')
NEW=$(gcloud compute instances describe "$(curl http://metadata.google.internal/computeMetadata/v1/instance/name -H Metadata-Flavor:Google)" --zone="$(curl http://metadata.google.internal/computeMetadata/v1/instance/zone -H Metadata-Flavor:Google)" | grep natIP | awk -F': ' '{print $2}')

cleanup() {
    gcloud dns record-sets transaction abort -z="$MANAGEDZONE"
}
trap cleanup ERR SIGINT

gcloud dns record-sets transaction start -z="$MANAGEDZONE"

gcloud dns record-sets transaction remove -z="$MANAGEDZONE" \
    --name="$DOMAIN" \
    --type=A \
    --ttl=300 "$EXISTING"

gcloud dns record-sets transaction add -z="$MANAGEDZONE" \
   --name="$DOMAIN" \
   --type=A \
   --ttl=300 "$NEW"

gcloud dns record-sets transaction execute -z="$MANAGEDZONE"
