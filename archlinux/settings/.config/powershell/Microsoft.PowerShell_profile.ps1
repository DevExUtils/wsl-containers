Import-Module PSFzf
Import-Module -Name Terminal-Icons

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-PSReadLineOption -PredictionSource History

Invoke-Expression (&starship init powershell)

Invoke-Expression (& {
    (zoxide init --hook pwd powershell --cmd j --no-aliases) -join "`n"
    })

New-Alias j __zoxide_zi -Force