# data-processing-vnet

## Deployment

Run the following Azure CLI command to deploy these resources.

```shell
az deployment group create --template-file=./infra/main.bicep --parameters=./infra/dev.parameters.json --resource-group rg-data-ussc-dev
```