param (
    [switch]$choco = $false,
    [switch]$dotfiles = $true,
    [switch]$escswap = $true,
    [switch]$local = $false
)

$ErrorActionPreference = "Stop"

if ($escswap) {
    regedit /s ".\windows\keyboard.reg"
}

if ($choco) {
    $hasChoco = Get-Command choco -ErrorAction SilentlyContinue 2>$null >$null
    if (!$hasChoco) {
        iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
    }

    $packages = @(
        "msys2", "ctags", "cmake", "7zip",
        "curl", "wget",
        "git", "tortoisesvn", "tortoisegit",
        "vim", "ask", "ag",
        "firefox", "thunderbird",
        "virtualbox",
        "keepassx"
    )
    choco install -y @packages
    Write-Host "Install python for vim"
}

if ($dotfiles) {
    $vimPlugFilePath = "~\vimfiles\autoload\plug.vim"
    $hasVimPlug = Test-Path $vimPlugFilePath -ErrorAction SilentlyContinue
    if (!$hasVimPlug) {
        md "~\vimfiles\autoload"
        $uri = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        $path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($vimPlugFilePath)
        (New-Object Net.WebClient).DownloadFile($uri, $path)
    }

    cp "$HOME\_vimrc" "dotfiles\.vimrc"
    cp "$HOME\.gitignore" "dotfiles\.gitignore"

    if ($local) {
        cp "$HOME\.vimrc.local" "local\.vimrc.local"
    }
}
