$ErrorActionPreference = "Stop"
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$hasChoco = Get-Command choco -ErrorAction SilentlyContinue 2>$null >$null
if (!$hasChoco) {
    iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
}

choco install -y vim msys2 firefox ctags git tortoisesvn
choco install -y tortoisegit python pip 7zip cmake
choco install -y thunderbird virtualbox keepassx

$hasVimPlug = Test-Path "~\vimfiles\autoload\plug.vim" -ErrorAction SilentlyContinue
if (!$hasVimPlug) {
    md ~\vimfiles\autoload
    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\vimfiles\autoload\plug.vim"))
}

cp -recurse dotfiles\.vim\* ~\vimfiles
cp dotfiles\.vimrc ~\_vimrc

