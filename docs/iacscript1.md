---
nav_exclude: True
---

# Security Group / Rule Powershell Script

[Back to Azure](azure.md)
[Back to Sec Groups](sec_groups_iac.md)

---
```powershell
# deploy 

#specialized to secGroup but lets leave it for now.
param (
    [string]$resourceGroupName,
    [string]$filePath,
    [string]$scriptType
    
)

$mainInput = ''

# Set a class to work as a struct but may have not needed the indexing
class CmdValue {
    [string]$value
    [int]$index

    CmdValue([string]$value, [int]$index) {
        $this.value = $value
        $this.index = $index
    }
}


# function to getInput for a value(param)
function getInput {
    param (
        [string]$value,
        [int]$index
    )

    $confirm = ''
    while ($confirm.ToLower() -ne "y" -and $confirm.ToLower() -ne "yes") {
        $userValue = Read-Host "Enter value for $value"
        $confirm = Read-Host "Confirm: $value = $userValue, Enter y or yes"
    }
    $commandValue = [CmdValue]::new($userValue, $index)

    return $commandValue
}

# For the help function
function printOptions {
    param(
        [CmdValue[]]$arr
    )
    for($i = 0; $i -lt $arr.Length; $i++) {
     Write-Host "$i." $arr[$i].value
   }
}

# changing choices of your list this works for any length
function changeChoices {
    param(
    [CmdValue[]]$arr
    )
    $len = $arr.Length - 1
    $exit = Read-Host "Enter value to change? Enter exit to quit."
    
    while ($exit -ne "exit") {
        if ($exit -notin 0..$len) {
            $exit = Read-Host "Enter a value in range. Or enter exit to quit"
        }
        else {
            $exit = [int]$exit
            $index = $arr[$exit].value
            $newValue = Read-Host "Enter new value for $index :"
            $confirm = ''
            while ($true) {
                $confirm = Read-Host "Confirm $newValue as new value? y/yes or no"
                if ($confirm -eq "y" -or $confirm -eq "yes") {
                    $arr[$exit].value = $newValue
                    break
                }
                else {
                    Write-Host "Not confirmed...."
                    break
                }
            }
            if ($confirm -eq "y" -or $confirm -eq "yes") {
                break
            } 
        }
    }
    return $arr
}

# declaring the read input functions

$secRule = getInput -value "Security Group Rule" -index 0
$desc = getInput -value "Description" -index 1
$proto = getInput -value "Protocol" -index 2
$destPort = getInput -value "Destination Port Range" -index 3
$sourceAddress = getInput -value "Source IP Address" -index 4
$access = getInput -value "Access" -index 5
$direction = getInput -value "Direction" -index 6


# a list of the commands (could) be improved
$cmdList = @(
    $secRule
    $desc
    $proto
    $destPort
    $sourceAddress
    $access
    $direction
)

# checking param
if ($scriptType -eq "sr") {
    $priority = getInput -value "Priority" -index 7
    $cmdList += $priority
}


# Main loop to run the cli tool and get all the information
$superConfirm = ''
$exitCheck = ''
while ($superConfirm -ne "y" -and $superConfirm -ne "yes" -and $superConfirm -ne "exit") {
   
   $superConfirm = Read-Host "Confirm these values y or yes and h or help to reprint"
   if ($superConfirm -eq "h" -or $superConfirm -eq "help") {
    Write-Host "Values:"
    printOptions -arr $cmdList
   }
   elseif ($superConfirm -ne "y" -or $superConfirm -ne "yes") {
   
    while ($true) {
        $exitCheck = Read-Host "Would you like to exit, or edit your values?"
        if ($exitCheck -eq "exit" -or $exitCheck -eq "edit" ) {
            break
        }
        Write-Host "Please Enter Exit or Edit"
    }
    if ($exitCheck -eq "edit") {
        Write-Host "Edititing"
        $newArr = changeChoices -arr $cmdList
    }
    else {
        Write-Host "Exiting"
        $newArr = $cmdList
        break
    }
   }
   else {
    continue
   }
}

# to be packaged into a param object
$params = @{
    secRule = [string]$newArr[0].value
    desc = [string]$newArr[1].value
    proto = [string]$newArr[2].value
    dest = [string]$newArr[3].value
    sourceip = [string]$newArr[4].value
    access = [string]$newArr[5].value
    direction = [string]$newArr[6].value
}

if ($scriptType -eq "sr") {
    $params["priority"] = [int]$newArr[7].value
    
}

# Try to deploy
try {
    New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $filePath `
    -TemplateParameterObject $params
}
catch {
    Write-Host ($_.Exception.Message)
}

```
---

