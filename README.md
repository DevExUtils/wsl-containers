# WSL-Setups

In this repository you can find default setups for various Linux based distributions.
The setups are supplied as Docker Containers that can be exported to .tar files and then imported into WSL as a distribution.

## Requirements

Build and setup one of the available WSL distributions the following software is required to be installed on your machine:

* Docker Desktop for building the container image and exporting it.
* WSL installed and enabled to import and run the WSL distribution.

### Windows Linux Subsystem (WSL)

1. Start a shell prompt as administrator
2. Run the following sell command:

```console
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

3. Download and install the [Linux Kernel update][Kernel] from Microsoft
4. Run the following shell commands:

```console
wsl --set-default-version 2
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
cd .\scripts\
. .\wsl-helpers.ps1
```
To map both your AWS CLI and Github CLI settings from Windows into your WSL run:

```console
Set-WSLDefaultSymlinks
```







[AboutWSL]: https://docs.microsoft.com/en-us/windows/wsl/about
[Kernel]: https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
[DockerDesktop]: https://docs.docker.com/desktop/install/windows-install/


