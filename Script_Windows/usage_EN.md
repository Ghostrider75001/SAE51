markdown
# Usage of VirtualBox VM Management Script

## Overview

This script automates the management of VirtualBox virtual machines (VMs), allowing users to create, delete, start, stop, and list VMs with metadata such as creation date and creator. The script captures error codes from commands and logs them into a file for easier debugging.

## Script Name

`genMV.sh`

## Prerequisites

- VirtualBox must be installed on your system.
- The `VBoxManage` command-line tool should be accessible from your terminal.
- An ISO image of Debian (netinst) should be available at the specified path in the script.
- Ensure that the TFTP server is set up correctly if using PXE boot options.

## How to Use

1. **Make the script executable:**

bash
   chmod +x genMV.sh

2. **Run the script with the appropriate command:**

   ### Command Options
   - `I` - List all registered VMs.
   - `L` - List all registered VMs with metadata (creation date and creator).
   - `N [VM_NAME]` - Create a new VM with the specified name (default is `Debian1`).
   - `S [VM_NAME]` - Delete the specified VM.
   - `D [VM_NAME]` - Start the specified VM.
   - `A [VM_NAME]` - Stop the specified VM.

   ### Example Usage
   - To create a new VM named `Debian1`:
   
   bash
   ./genMV.sh N Debian1

   - To list all VMs with their metadata:

   bash
   ./genMV.sh L

3. **Error Logging:**
   - If any command fails, the error code and the command that failed will be logged into a file named `error_genMV.sh.txt`.
   - The error log file will automatically open after the script finishes executing.

## Limitations

- The script is designed to manage one VM at a time. Attempting to create multiple VMs simultaneously may lead to conflicts.
- The script assumes that the default VM name is `Debian1` unless otherwise specified. If a VM with the same name exists, it will be deleted automatically.
- Ensure that the specified paths for the ISO image and TFTP server are correct and accessible.

## Common Issues

- **Permission Denied**: If you encounter a permission error while running the script, ensure that you have the necessary permissions to execute `VBoxManage` commands.
- **Missing ISO**: If the ISO file path is incorrect or the file does not exist, the script will fail during the VM creation process.
- **VirtualBox Not Found**: If `VBoxManage` is not found, ensure that VirtualBox is installed and that its binaries are in your system's PATH.

## Conclusion

This script simplifies the management of VirtualBox VMs through automated commands and error logging. For any issues or feature requests, please contact the script maintainer.
