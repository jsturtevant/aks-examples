## Set up infrastructure 

### Setup Pre-requisites: vnet, public ips, acr

```bash
cd pre-reqs
terraform init
terraform apply
cd ..
```

Set up a few varaibles we will use through out the next steps:

```bash
subid=$(az account show -o json | jq -r .id)
subnetid=$(az network vnet subnet show -n aks-subnet -g tmp-lpsp-vnet --vnet-name lpsp-network | jq -r .id)

spname=tmp-lpsp-sp
acrname=lpspacr
aksclustername=lpsp-aks-cluster
aksrg=tmp-lpsp-aks
```

## Create the Service Principle with least amount of required permissions
First update the Custom Role Definitions to use your subscription ID:

```
sed -i 's|SUBID|'${subid}'|g' role-definitions/aks-reader.json
sed -i 's|SUBID|'${subid}'|g' role-definitions/vnet-reader.json
```

This will create and assign roles to the service principle.  

``bash
# Create a service principle (if you already have one then can skip creation)
clientsecret=$(az ad sp create-for-rbac --skip-assignment -n $spname -o json | jq -r .password)

# This uses the defaults which can be overridden (see script)
./create-aks-sp.sh $spname
```

## Create AKS cluster with the Service Principle

```bash
clientid=$(az ad sp show --id "http://$spname" | jq -r .appId)

cd aks
terraform init
terraform apply --var "vnet_subnet_id=$subnetid" \
    --var "client_id=$clientid" \
    --var "subscription_id=$subid" \
    --var "client_secret=$clientsecret" \
    --var-file dev.tfvars
cd ..
```

> note: Client secret was set when `create-aks-sp.sh` was run.  If you were adding permissions to an existing Service Principle you will need to set `$clientsecret` manually.

## Test IP address creation
You can confirm your deployment into the vnet by looking at the ip addresses allocated.

Build an image and store it in ACR:

```bash
cd k8s
az acr build --registry $acrname --image whoami:v1 .
```

To test IP allocation and pulling from ACR:

```bash
serverlogin=$(az acr show --name $acrname --query loginServer --output tsv)

az aks get-credentials -n $aksclustername -g $aksrg
kubectl create secret docker-registry acr-auth --docker-server $serverlogin \
    --docker-username $clientid \
    --docker-password $clientsecret \
    --docker-email test@test.com

ipaddress=$(az network public-ip list --resource-group tmp-lpsp-ip --query "[0].ipAddress" --output tsv)
sed -i 's|IPADDRESS|'${ipaddress}'|g' deployment.yml

kubectl apply -f deployment.yaml
```