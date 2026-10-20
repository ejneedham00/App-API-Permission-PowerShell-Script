Connect-MgGraph -Scopes "Application.Read.All","Directory.Read.All"


# Set the variables for the App ID and assigned permission you want to find
$ApiAppId = "********-****-****-****-************"
$PermissionName = "user.readwrite.all"

# Get the API Service Principal
$ApiSP = Get-MgServicePrincipal -Filter "appId eq '$ApiAppId'"

if (-not $ApiSP) {
    Write-Error "API Service Principal not found."
    return
}

# Find the permission
$Permission = $ApiSP.AppRoles | Where-Object {
    $_.Value -eq $PermissionName
}

if (-not $Permission) {
    Write-Error "Permission '$PermissionName' not found on API."
    return
}

# Get all assignments for this permission
$Assignments = Get-MgServicePrincipalAppRoleAssignedTo `
    -ServicePrincipalId $ApiSP.Id `
    -All |
    Where-Object {
        $_.AppRoleId -eq $Permission.Id
    }

$Results = foreach ($Assignment in $Assignments) {

    $SP = Get-MgServicePrincipal -ServicePrincipalId $Assignment.PrincipalId

    [PSCustomObject]@{
        ApplicationName = $SP.DisplayName
        AppId           = $SP.AppId
        ObjectId        = $SP.Id
        Permission      = $PermissionName
    }
}

$Results | Sort-Object ApplicationName | Format-Table -AutoSize

# Export
$Results | Export-Csv ".\AppsAPIPermission.csv" -NoTypeInformation
