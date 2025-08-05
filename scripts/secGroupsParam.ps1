# deploy 

#specialized to secGroup but lets leave it for now.
param (
    [string]$scriptType
)

$mainInput = ''

class CmdValue {
    [string]$value
    [int]$index

    CmdValue([string]$value, [int]$index) {
        $this.value = $value
        $this.index = $index
    }
}



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





$secRule = getInput -value "Security Group" -index 0
$desc = getInput -value "Description" -index 1
$proto = getInput -value "Protocol" -index 2
$sourcePort = getInput -value "Source Port Range" -index 3
$destPort = getInput -value "Destination Port Range" -index 4
$sourceAddress = getInput -value "Source IP Address" -index 5
$access = getInput -value "Access" -index 6
$direction = getInput -value "Direction" -index 7
    
$cmdList = @(
    $secRule
    $desc
    $proto
    $sourcePort
    $destPort
    $sourceAddress
    $access
    $direction
)

if ($scriptType -eq "sr") {
    $priority = getInput -value "Priority" -index 8
    $cmdList += $priority
}

$superConfirm = ''

while ($superConfirm -ne "y" -and $superConfirm -ne "yes") {
   for($i = 0; $i -lt $cmdList.Length; $i++) {
     Write-Host $cmdList[$i].value
     
   }
   $superConfirm = Read-Host "Confirm these values?"
}
Write-Host $secRule.value $secRule.index