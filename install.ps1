param (
    [switch]$choco = $false,
    [switch]$vim = $true
)

$ErrorActionPreference = "Stop"

if ($choco) {
    $hasChoco = Get-Command choco -ErrorAction SilentlyContinue 2>$null >$null
    if (!$hasChoco) {
        iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
    }

    $packages = @(
        "vim", "msys2", "firefox", "ctags", "git", "tortoisesvn",
        "tortoisegit", "pip", "7zip", "cmake",
        "python", "-version", "3.5.1",
        "lua51",       "thunderbird", "virtualbox", "keepassx"
    )
    choco install -y @packages
}

if ($vim) {
    $vimPlugFilePath = "~\vimfiles\autoload\plug.vim"
    $hasVimPlug = Test-Path $vimPlugFilePath -ErrorAction SilentlyContinue
    if (!$hasVimPlug) {
        md "~\vimfiles\autoload"
        $uri = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        $path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($vimPlugFilePath)
        (New-Object Net.WebClient).DownloadFile($uri, $path)
    }

    cp "dotfiles\.vimrc" "~\_vimrc"
}
