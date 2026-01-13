#mapNetDrive.ps1

# ==============================================================================
# SECTION 1: CONFIGURATION VARIABLES
# Sets the core parameters for the drive mapping.
# ==============================================================================
$DriveLetter = "Z"                        # The letter assigned to the mapped drive
$NetworkPath = "\\ServerName\SharedFolder" # The target network share path (UNC path)


# ==============================================================================
# SECTION 2: CLEANUP PRE-EXISTING MAPPINGS
# Checks if the chosen drive letter is already in use. If it is, the script 
# forces a removal to prevent "Drive already exists" errors during the new mapping.
# ==============================================================================
if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) {
    # -Force ensures the drive is removed even if files are currently open
    Remove-PSDrive -Name $DriveLetter -Force
}


# ==============================================================================
# SECTION 3: CREDENTIAL COLLECTION
# Triggers a secure Windows login prompt. This allows the script to use a 
# username and password that differ from the current laptop session.
# ==============================================================================
$cred = Get-Credential


# ==============================================================================
# SECTION 4: NETWORK DRIVE MAPPING
# Executes the mapping with specific parameters to ensure visibility and persistence.
# ==============================================================================
New-PSDrive -Name $DriveLetter `
    -PSProvider FileSystem `
    -Root $NetworkPath `
    -Credential $cred `
    -Persist `
    -Scope Global
# ------------------------------------------------------------------------------
# PARAMETER BREAKDOWN:
# -PSProvider FileSystem: Required for mapping actual network storage.
# -Persist: Ensures the drive remains available after the computer reboots.
# -Scope Global: Makes the drive visible to all processes, including File Explorer.
# ==============================================================================
