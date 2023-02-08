Function Set-WSLDefaultSymlinks {

    process {
        $GHCLIPath = Convert-WSLPath -Path "$env:APPDATA\GitHub CLI"
        Set-WSLSymLink -SourcePath $GHCLIPath -DestinationPath ~/.config/gh

        $GHCLIPath = Convert-WSLPath -Path "$env:UserProfile\.aws"
        Set-WSLSymLink -SourcePath $GHCLIPath -DestinationPath ~/.aws
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