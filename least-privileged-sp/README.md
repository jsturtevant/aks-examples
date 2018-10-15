## Set up infrastructure 

### Setup Pre-requisites: vnet, public ips, acr

```bash
cd pre-reqs
terraform init
terraform apply terraform
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
# This uses the defaults which can be overridden (see script)
./create-aks-sp.sh
```
