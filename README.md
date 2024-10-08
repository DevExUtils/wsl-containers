# WSL-Containers

In this repository you can find default setups for various Linux based distributions.
The setups are supplied as Docker Containers that can be exported to .tar files and then imported into WSL as a distribution.

## Requirements

Build and setup one of the available WSL distributions the following software is required to be installed on your machine:

* Docker Desktop for building the container image and exporting it.
* WSL installed and enabled to import and run the WSL distribution.

### Windows Linux Subsystem (WSL)

1. Start a shell prompt as administrator
2. Run the following sell commands:

```console
# Enables Hyper-V Tier 1 Hypervisor features
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Installs Windows Store version of WSL without a default distrobution
wsl --install --no-distribution

# Use WSL version 2 as default
wsl --set-default-version 2

# Check for updates to WSL
wsl --update
```

### Docker Desktop

Docker Desktop depends on you already having installed WSL.

**Install through console**:

1. Start a shell prompt as administrator
2. Run the following sell command:

```console
winget install -e --id Docker.DockerDesktop
```

**Install through GUI**:

1. Go to the [Docker Desktop installation][DockerDesktop] website
2. Download and install

## Current supported distributions:

All the available distributions have a README file with install instructions available in their respective folder.
Currently supported Linux Distributions are:

* ArchLinux

## Support scripts

After setting up your WSL distribution, you might want to map files or folders from your host Windows PC into WSL.
The folder `./scripts` contains a PowerShell file with commands you can import into your shell session and run.

From a PowerShell console, cd into the `./scripts` folder.
Then import the shell commands into your current session by running:

```console
. .\scripts\wsl-helpers.ps1
```

To map both your AWS CLI and Github CLI settings from Windows into your WSL run:

```console
Set-WSLDefaultSymlinks
```

### Installation with script

Run the following commands to install via Script:

```powershell
# From the root of the directory run in PowerShell:
. .\scripts\wsl-helpers.ps1

# Then change into the archlinux folder:
cd archlinux

# Finally run the install script.
Install-LinuxDistribution -UserName "initials" -Name "Firstname Lastname" -Email "mail@domain.tld" -LinuxDistroName ArchLinux
```

[AboutWSL]: https://docs.microsoft.com/en-us/windows/wsl/about
[DockerDesktop]: https://docs.docker.com/desktop/install/windows-install/
