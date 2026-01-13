#mapNetDrive.ps1

# ==============================================================================
# SECTION 1: CONFIGURATION VARIABLES
# Sets the core parameters for the drive mapping.
# ==============================================================================

#TODO: I may add functionality that suggests another letter if the T: is in use. 
$DriveLetter = "T"                        # The letter assigned to the mapped drive
$NetworkPath = "\\172.16.30.18\Carlton Office\Technical\" # The target network share path (UNC path)


# ==============================================================================
# SECTION 2: CLEANUP PRE-EXISTING MAPPINGS
# Checks if the chosen drive letter is already in use. If it is, the script 
# forces a removal to prevent "Drive already exists" errors during the new mapping.
# ==============================================================================
try {
if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) {
    # -Force ensures the drive is removed even if files are currently open
    Remove-PSDrive -Name $DriveLetter -Force
    Write-host "Removed existing drive mapping for $DriveLetter." -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to remove pre-existing mapping for drive $DriveLetter. Error: $_" -ForegroundColor Red
    exit
}


# ==============================================================================
# SECTION 3: CREDENTIAL COLLECTION
# Triggers a secure Windows login prompt. This allows the script to use a 
# username and password that differ from the current laptop session.
# ==============================================================================
Write-Host "Please provide network credentials to map $NetworkPath." -ForegroundColor Cyan     #added a prompt for the user to understand why they're getting asked for credentials. 
$cred = Get-Credential


# ==============================================================================
# SECTION 4: NETWORK DRIVE MAPPING
# Executes the mapping with specific parameters to ensure visibility and persistence.
# ==============================================================================
try {
    New-PSDrive -Name $DriveLetter `
        -PSProvider FileSystem `
        -Root $NetworkPath `
        -Credential $cred `
        -Persist `
        -Scope Global        #May not need global scope...
    Write-Host "Successfully mapped drive $DriveLetter to $NetworkPath." -ForgroundColor Green
} catch {
    Write-Host "Failed to map drive $DriveLetter to $NetworkPath." -ForgroundColor Red
    exit
}
# ------------------------------------------------------------------------------
# PARAMETER BREAKDOWN:
# -PSProvider FileSystem: Required for mapping actual network storage.
# -Persist: Ensures the drive remains available after the computer reboots.
# -Scope Global: Makes the drive visible to all processes, including File Explorer.
# ==============================================================================
