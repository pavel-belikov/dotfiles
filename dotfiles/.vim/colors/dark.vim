hi clear
set background=dark
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "dark"

hi  LightGreenOnGray  ctermfg=green        ctermbg=lightgray
hi  LightGreenOnGray  guifg=#50ff50        guibg=#151515
hi  OnGreen           guibg=#086008        ctermbg=darkgreen
hi  OnBlue            guibg=#008cff        ctermbg=darkcyan
hi  OnDarkBlue        guibg=#0045ff        ctermbg=blue
hi  OnPurple          guibg=#5555ff        ctermbg=blue
hi  OnRed             guibg=#ff3c3c        ctermbg=red
hi  OnOrange          guibg=#aa5500        ctermbg=darkyellow guifg=#cccccc ctermfg=white

hi  LightGreen        ctermfg=green        guifg=#50ff50
hi  LightYellow       ctermfg=yellow       guifg=#ffff30
hi  LightCyan         ctermfg=cyan         guifg=#55ffff
hi  LightRed          ctermfg=red          guifg=#ff3c3c
hi  Magenta           ctermfg=magenta      guifg=#e64ce6
hi  Purple            ctermfg=blue         guifg=#5555ff
hi  Orange            ctermfg=darkyellow   guifg=#aa5500
hi  Blue              ctermfg=darkcyan     guifg=#008cff

hi  OnDarkGray        ctermbg=lightgray    guibg=#121212
hi  OnDarkGray2       ctermbg=lightgray    guibg=#151515
hi  OnDarkGray3       ctermbg=lightgray    guibg=#202020

hi  Normal            ctermfg=white        ctermbg=black       guifg=#cccccc  guibg=#0c0c0c
hi  Scrollbar         ctermfg=cyan         ctermbg=darkcyan    guifg=#55ffff  guibg=#008cff
hi  Title             ctermfg=darkmagenta  guifg=#a000a0
hi  Menu              ctermfg=black        ctermbg=cyan        guifg=#0c0c0c  guibg=#55ffff
hi  Cursor            ctermfg=bg           ctermbg=green       guifg=bg       guibg=#50ff50
hi  Visual            ctermfg=white        ctermbg=darkcyan    guifg=#cccccc  guibg=#004588

hi! link Variable Normal

hi   Namespace     ctermfg=green  guifg=#50ff50
hi   Member        cterm=italic   ctermfg=cyan   gui=italic  guifg=#6ad8b8
hi   EnumConstant  ctermfg=green  guifg=#90ee90

hi!  link  VertSplit                  LightGreenOnGray
hi!  link  SpecialKey                 LightRed
hi!  link  NonText                    LightRed
hi!  link  Directory                  Blue
hi!  link  ErrorMsg                   OnRed
hi!  link  Search                     OnOrange
hi!  link  MoreMsg                    OnGreen
hi!  link  ModeMsg                    OnPurple
hi!  link  LineNr                     LightGreenOnGray
hi!  link  CursorLineNr               LightYellow
hi!  link  ColorColumn                OnDarkGray3
hi!  link  Question                   OnGreen
hi!  link  StatusLine                 OnDarkBlue
hi!  link  StatusLineNC               OnDarkGray
hi!  link  WarningMsg                 OnRed
hi!  link  Comment                    LightCyan
hi!  link  Constant                   LightRed
hi!  link  String                     Magenta
hi!  link  Special                    Orange
hi!  link  Identifier                 Blue
hi!  link  Statement                  LightYellow
hi!  link  Operator                   LightYellow
hi!  link  PreProc                    Purple
hi!  link  Type                       LightGreen
hi!  link  Error                      Blue
hi!  link  Todo                       Blue
hi!  link  CursorLine                 OnDarkGray2
hi!  link  CursorColumn               OnDarkGray2
hi!  link  MatchParen                 LightRed
hi!  link  TabLine                    OnDarkGray
hi!  link  TabLineFill                OnDarkGray3
hi!  link  TabLineSel                 OnPurple
hi!  link  PMenu                      OnDarkGray3
hi!  link  PMenuSel                   OnGreen
hi!  link  DiffAdd                    OnGreen
hi!  link  DiffChange                 OnOrange
hi!  link  DiffRemove                 OnRed
hi!  link  Folded                     OnGreen
hi!  link  StatusLineNormalMode       OnOrange
hi!  link  StatusLineInsertMode       OnGreen
hi!  link  StatusLineVisualMode       OnRed
hi!  link  ExtraWhitespace            OnRed

hi!  link  IndentGuidesOdd            OnDarkGray
hi!  link  IndentGuidesEven           OnDarkGray2

hi!  link  SignColumn                 OnDarkGray

hi!  link  IncSearch                  Visual
hi!  link  Character                  String
hi!  link  Number                     Constant
hi!  link  Boolean                    Keywoard
hi!  link  Float                      Number
hi!  link  Function                   Identifier
hi!  link  Conditional                Statement
hi!  link  Repeat                     Statement
hi!  link  Label                      Statement
hi!  link  Keyword                    Statement
hi!  link  Exception                  Statement
hi!  link  Include                    PreProc
hi!  link  Define                     PreProc
hi!  link  Macro                      PreProc
hi!  link  PreCondit                  PreProc
hi!  link  StorageClass               Type
hi!  link  Structure                  Type
hi!  link  Class                      Type
hi!  link  Typedef                    Type
hi!  link  Tag                        Special
hi!  link  SpecialChar                Special
hi!  link  Delimiter                  Special
hi!  link  SpecialComment             Special
hi!  link  Debug                      Special
hi!  link  DiffText                   Normal

hi!  link  TagbarComment              Comment
hi!  link  TagbarKind                 Keyword
hi!  link  TagbarNestedScope          Keyword
hi!  link  TagbarScope                Type
hi!  link  TagbarType                 Type
hi!  link  TagbarSignature            Special
hi!  link  TagbarPseudoID             PreProc
hi!  link  TagbarFoldIcon             Operator
hi!  link  TagbarHighlight            PMenuSel
hi!  link  TagbarVisibilityPublic     Keyword
hi!  link  TagbarVisibilityProtected  Keyword
hi!  link  TagbarVisibilityPrivate    Keyword

hi!  link  cEnumTag                   Type
hi!  link  cMemberTag                 Type
hi!  link  cTypeTag                   Type
hi!  link  cPreProcTag                PreProc
hi!  link  cFunctionTag               Function
hi!  link  cBoolean                   Keyword
hi!  link  cppSTLnamespace            Type
hi!  link  cppStructure               Keyword

hi!  link  NERDTreePart               Normal
hi!  link  NERDTreePartFile           Normal
hi!  link  NERDTreeFile               Normal
hi!  link  NERDTreeClosable           LightGreen
hi!  link  NERDTreeBookmarksHeader    Statement
hi!  link  NERDTreeBookmarksLeader    Ignore
hi!  link  NERDTreeBookmarkName       Identifier
hi!  link  NERDTreeBookmark           Normal
hi!  link  NERDTreeHelp               Comment
hi!  link  NERDTreeHelpKey            Identifier
hi!  link  NERDTreeHelpCommand        Identifier
hi!  link  NERDTreeHelpTitle          Macro
hi!  link  NERDTreeToggleOn           Question
hi!  link  NERDTreeToggleOff          WarningMsg
hi!  link  NERDTreeDir                Directory
hi!  link  NERDTreeUp                 Directory
hi!  link  NERDTreeDirSlash           Directory
hi!  link  NERDTreeCWD                Statement
hi!  link  NERDTreeLinkTarget         Type
hi!  link  NERDTreeLinkFile           LightCyan
hi!  link  NERDTreeLinkDir            LightCyan
hi!  link  NERDTreeOpenable           LightGreen
hi!  link  NERDTreeFlag               Ignore
hi!  link  NERDTreeRO                 WarningMsg
hi!  link  NERDTreeBookmark           Statement
hi!  link  NERDTreeCurrentNode        Search
