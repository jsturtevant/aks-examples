#!/bin/bash
set -x
set -o errexit
set -o nounset
set -o pipefail

# Usage: create-aks-sp.sh <sp-name> <vnet-name> <vnet-rg> <ip-rg> <acr-name>
NAME=${1:-tmp-lpsp-sp}
VNET_NAME=${2:-lpsp-network}
VNET_RG=${3:-tmp-lpsp-vnet}
IP_RG=${4:-tmp-lpsp-ip}
ACR_NAME=${4:-lpspacr}

IP_ROLE_NAME="AKS IP Role"
VNET_ROLE_NAME="AKS VNet Role"

# create service principle with no permissions
sp=$(az ad sp show --id "http://$NAME")
if [[ -z "$sp" ]]; then
    # no sp let's create one
    echo "Creating sp..."
    az ad sp create-for-rbac --skip-assignment -n $NAME
fi

spid=$(az ad sp show --id "http://$NAME" | jq -r .objectId)

# create custom roles
iprole=$(az role definition list -n "$IP_ROLE_NAME" -o json | jq '.[]')
if [[ -z "$iprole" ]]; then
    # role not found 
    iprole=$(az role definition create --role-definition ./role-definitions/aks-reader.json)
fi

vnetrole=$(az role definition list -n "$VNET_ROLE_NAME" -o json | jq '.[]')
if [[ -z "$vnetrole" ]]; then
    # role not found 
    vnetrole=$(az role definition create --role-definition ./role-definitions/vnet-reader.json)
fi

# Assign permission to the vnet
vnetid=$(az network vnet show -n $VNET_NAME -g $VNET_RG | jq -r .id)
vnetRA=$(az role assignment list --role "$VNET_ROLE_NAME" --scope $vnetid --assignee $spid | jq '.[]')
if [[ -z "$vnetRA" ]]; then
    # role not found 
    az role assignment create --role "$VNET_ROLE_NAME" --scope $vnetid --assignee-object-id $spid
fi

# Assign permission to the RG with the IP's
ipRA=$(az role assignment list --role "$IP_ROLE_NAME" --resource-group $IP_RG  --assignee $spid | jq '.[]')
if [[ -z "$ipRA" ]]; then
    # role not found 
    az role assignment create --role "$IP_ROLE_NAME" --resource-group $IP_RG --assignee-object-id $spid
fi

# Assign permission to the ACR
acrid=$(az acr show -n $ACR_NAME | jq -r .id)
acrRA=$(az role assignment list --role "Reader" --scope $acrid --assignee $spid | jq '.[]')
if [[ -z "$acrRA" ]]; then
    # role not found 
    az role assignment create --role "Reader" --scope $acrid --assignee-object-id $spid
fi

