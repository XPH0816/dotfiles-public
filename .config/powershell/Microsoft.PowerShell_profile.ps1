#oh-my-posh --init --shell pwsh --config $env:userprofile\.config\powershell\1_shell.omp.json | Invoke-Expression

#function Invoke-PhpArtisan { [Alias('pa')] param() php artisan $args }

#Import-Module Terminal-Icons
#Import-Module posh-git

Set-Alias k kubectl
Set-Alias g goto
Set-Alias lg lazygit

function l { lsd -la }

function Invoke-PhpArtisan { [Alias('pa')] param() php artisan $args }

function goto {
    param (
        $location
    )

    Switch ($location) {
        "pr" {
            Set-Location -Path "E:/Project"
        }
        "t" {
            Set-Location -Path "E:/Test Code"
        }
        "dp" {
            Set-Location -Path "$HOME/dotfiles-public"
        }
        default {
            Write-Output "Invalid location"
        }
    }
}

function mklink($path, $target) {
    New-Item -ItemType SymbolicLink -Path $path -Target $target
}

function kn {
    param (
        $namespace
    )

    if ($namespace -in "default","d") {
        kubectl config set-context --current --namespace=default
    } else {
        kubectl config set-context --current --namespace=$namespace
    }
}

function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }
}

$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
$ENV:STARSHIP_DISTRO = "  $env:username "
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String)  })