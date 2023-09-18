Function Set-WSLDefaultSymlinks {

    process {
        $GHCLIPath = Convert-WSLPath -Path "$env:APPDATA\GitHub CLI"
        Set-WSLSymLink -SourcePath $GHCLIPath -DestinationPath ~/.config/gh

        $AWSConfigPath = Convert-WSLPath -Path "$env:UserProfile\.aws"
        Set-WSLSymLink -SourcePath $AWSConfigPath -DestinationPath ~/.aws
    }
}


Function Set-WSLSymLink {

    [CmdletBinding()]
    Param(

        [Parameter(Position=0, Mandatory=$True)]
        [string]$SourcePath,

        [Parameter(Position=1, Mandatory=$True)]
        [string]$DestinationPath,

        [Parameter(Position=2, Mandatory=$False)]
        [Alias('d')]
        [string]$Distribution,

        [Parameter(Position=3, Mandatory=$False)]
        [Alias('u')]
        [string]$User
    )

    process {
        if ($PSBoundParameters.ContainsKey('Distribution')) {
            wsl -d $Distribution ln -s $SourcePath $DestinationPath
        }
        if ($PSBoundParameters.ContainsKey('User')) {
            wsl -u $User ln -s $SourcePath $DestinationPath
        }
        if ($PSBoundParameters.ContainsKey('Distribution') -and $PSBoundParameters.ContainsKey('User')) {
            wsl -d $Distribution -u $User ln -s $SourcePath $DestinationPath
        }
        else {
            wsl ln -s $SourcePath $DestinationPath
        } 
    }
}


Function Convert-WSLPath {

    [CmdletBinding()]
    [Alias("wslpath")]

    Param(

        [Parameter(
            Position = 0,
            Mandatory = $True
        )]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [ValidateSet('-u', '-w', '-m')]
        $Argument = '-u',

        [Parameter(Mandatory = $False)]
        [Alias('Distro')]
        [string]$Distribution,

        [Parameter(Mandatory = $False)]
        [string]$User
    )

    process {
        if ($PSBoundParameters.ContainsKey('Distribution')) {
            wsl -d $Distribution 'wslpath' $Argument $Path.Replace('\', '\\');
        }
        if ($PSBoundParameters.ContainsKey('User')) {
            wsl -u $User 'wslpath' $Argument $Path.Replace('\', '\\');
        }
        if ($PSBoundParameters.ContainsKey('Distribution') -and $PSBoundParameters.ContainsKey('User')) {
            wsl -d $Distribution -u $User 'wslpath' $Argument $Path.Replace('\', '\\');
        }
        else {
            wsl 'wslpath' $Argument $Path.Replace('\', '\\');
        }
    }
}

Function Install-LinuxDistribution {

    [CmdletBinding()]
    
    Param(

        [Parameter(Position = 0, Mandatory = $true)]
        [string]$UserName,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Name,

        [Parameter(Position = 2, Mandatory = $true)]
        [string]$Email,

        [Parameter(Position = 3,Mandatory = $true)]
        #[ValidateSet("archlinux")]
        [string]$LinuxDistroName
    )

    begin {
        $ContainerName = "$($LinuxDistroName.ToLower())-container"
        $TarFileName = "$($ContainerName).tar"
    }

    process {
        Write-Output "Building Docker Container Image"
        docker build --build-arg USERNAME=$UserName --build-arg NAME=$Name --build-arg EMAIL=$Email -t "$($ContainerName):latest" .

        Write-Output "Running Container and Exporting filesystem to .tar file"
        docker run --name $ContainerName "$($ContainerName):latest"
        docker export $ContainerName -o $TarFileName

        Write-Output "Removing Container"
        docker rm -f $ContainerName

        if (-Not (Test-Path c:\wsl)) {
            Write-Output "WSL Path not found, Creating"
            New-Item -Path "c:\" -Name "wsl" -ItemType "directory"
        } 

        if (-Not (Test-Path c:\wsl\$LinuxDistroName)) {
            Write-Output "c:\wsl\$LinuxDistroName Path not found. Creating Directory"
            New-Item -Path "c:\wsl" -Name $LinuxDistroName -ItemType "directory"
        } 

        Write-Output "Moving $TarFileName to WSL root folder"
        mv ".\$TarFileName" "C:\wsl\$LinuxDistroName\$TarFileName"

        Write-Output "Importing $TarFileName as a WSL Linux Distribution called $LinuxDistroName"
        wsl --import "$LinuxDistroName" "C:\wsl\$LinuxDistroName" "C:\wsl\$LinuxDistroName\$TarFileName"

        Write-Output "Removing $TarFileName from system"
        rm "C:\wsl\$LinuxDistroName\$TarFileName"

        Write-Output "Removing /.dockerenv file from WSL filesystem"
        wsl -d $LinuxDistroName -u $UserName sudo rm /.dockerenv
    }
}