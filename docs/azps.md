---
nav_exclude: true
---

# Azure Powershell Helpers


## Installing AZ Module:

---
```powershell
# Open Powershell as an Admin
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```
---

## Login to Azure Account:

---
```powershell
Connect-AzAccount
```
---

## Create Resource Group

---
```powershell
New-AzResourceGroup -Name "Resource Name" -Location "Location"
```
---

## Create Resource Group in Azure

---

- Click Hamburger Dropdown and select Resource Groups:

---
![Screenshot](./images/az_help/az_r1.png)

- Click Create and Type in a Name

---
![Screenshot](./images/az_help/az_r2.png)

- Click Review & Create

---
![Screenshot](./images/az_help/az_r3.png)

- Click Create

---
![Screenshot](./images/az_help/az_r4.png)

- Your Group is Created!

---
![Screenshot](./images/az_help/az_r5.png)


## Confirm Resource Group

---
```powershell
Get-AzResourceGroup
ResourceGroupName : TestGroup
Location          : westus2
ProvisioningState : Succeeded
Tags              :
ResourceId        : /subscriptions/a63485bf-c8f9-49c4-97d7-30b813966f8e/resourceGroups/TestGroup
```
---

## Basic Script Deployment

---
```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "TestGroup" `
  -TemplateFile "testgroupvm.bicep" `
  -TemplateParameterObject @{
    auser="tuser"
    apass="tpass"
  }
```
---


