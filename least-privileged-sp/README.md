## Set up infrastructure 

### Setup Pre-requisites: vnet, public ips, acr

```bash
cd pre-reqs
terraform init
terraform apply
cd ..
```

## Create the Service Principle with least amount of required permissions
First update the Custom Role Definitions to use your subscription ID:

```
subid=<your sub id>
sed -i 's|SUBID|'${subid}'|g' role-definitions/aks-reader.json
sed -i 's|SUBID|'${subid}'|g' role-definitions/vnet-reader.json
```

This will create and assign roles to the service principle.  

``bash
# Create a service principle (if you already have one then can skip creation)
NAME=tmp-lpsp-sp
clientsecret=$(az ad sp create-for-rbac --skip-assignment -n $NAME -o json | jq -r .password)

# This uses the defaults which can be overridden (see script)
./create-aks-sp.sh $NAME
```

## Create AKS cluster with the Service Principle

```bash
clientid=$(az ad sp show --id "http://$NAME" | jq -r .appId)
subnetid=$(az network vnet subnet show -n aks-subnet -g tmp-lpsp-vnet --vnet-name lpsp-network | jq -r .id)
subid=$(az account show -o json | jq -r .id)

cd aks
terraform init
terraform apply --var "vnet_subnet_id=$subnetid" \
    --var "client_id=$clientid" \
    --var "subscription_id=$subid" \
    --var "client_secret=$clientsecret" \
    --var-file dev.tfvars
```

> note: Client secret was set when `create-aks-sp.sh` was run.  If you were adding permissions to an existing Service Principle you will need to set `$clientsecret` manually.