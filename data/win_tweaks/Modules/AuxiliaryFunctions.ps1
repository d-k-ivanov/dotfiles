##########
#region Auxiliary Functions
##########

# Wait for key press
Function WaitForKey
{
    Write-Output "`nPress any key to continue..."
    [Console]::ReadKey($true) | Out-Null
}

# Restart computer
Function Restart
{
    Write-Output "Restarting..."
    Restart-Computer
}

##########
#endregion Auxiliary Functions
##########
