hi clear
set background=dark
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "dark"

"Console colors
hi Normal               cterm=none            ctermfg=white            ctermbg=black
hi Scrollbar            cterm=none            ctermfg=cyan             ctermbg=darkcyan
hi VertSplit            cterm=none            ctermfg=lightgreen       ctermbg=lightgray
hi Menu                 cterm=none            ctermfg=black            ctermbg=cyan
hi SpecialKey           cterm=none            ctermfg=red
hi NonText              cterm=none            ctermfg=red
hi Directory            cterm=none            ctermfg=darkyellow
hi ErrorMsg             cterm=bold            ctermfg=white            ctermbg=red
hi Search               cterm=none            ctermfg=white            ctermbg=darkyellow
hi MoreMsg              cterm=bold            ctermfg=darkgreen
hi ModeMsg              cterm=bold            ctermfg=white            ctermbg=blue
hi LineNr               cterm=none            ctermfg=green            ctermbg=lightgray
hi CursorLineNr         cterm=none            ctermfg=yellow           ctermbg=black
hi ColorColumn                                                         ctermbg=lightgray
hi Question             cterm=bold            ctermfg=darkgreen
hi StatusLine           cterm=underline       ctermfg=white            ctermbg=darkblue
hi StatusLineNC         cterm=underline       ctermfg=white            ctermbg=bg
hi Title                cterm=bold            ctermfg=darkmagenta
hi Visual               cterm=none                                     ctermbg=grey
hi WarningMsg           cterm=bold            ctermfg=darkred
hi Cursor                                     ctermfg=bg               ctermbg=green
hi Comment                                    ctermfg=cyan
hi Constant                                   ctermfg=red
hi String                                     ctermfg=magenta
hi Special                                    ctermfg=darkyellow
hi Identifier           cterm=none            ctermfg=darkcyan
hi cEnumTag             cterm=bold            ctermfg=lightgreen
hi cMemberTag           cterm=bold            ctermfg=lightgreen
hi Statement            cterm=none            ctermfg=yellow
hi Operator             cterm=none            ctermfg=yellow
hi PreProc                                    ctermfg=blue
hi Type                 cterm=none            ctermfg=green
hi Error                                      ctermfg=darkcyan         ctermbg=black
hi Todo                                       ctermfg=darkcyan         ctermbg=bg
hi CursorLine           cterm=none                                     ctermbg=grey
hi CursorColumn                                                        ctermbg=grey
hi MatchParen           cterm=none            ctermfg=red              ctermbg=bg
hi TabLine              cterm=underline       ctermfg=white            ctermbg=darkgrey
hi TabLineFill          cterm=underline       ctermfg=white            ctermbg=grey
hi TabLineSel           cterm=underline       ctermfg=white            ctermbg=blue
hi PMenu                                      ctermfg=white            ctermbg=lightgrey
hi PMenuSel             cterm=bold            ctermfg=white            ctermbg=darkgreen
hi DiffAdd              cterm=none            ctermfg=white            ctermbg=darkgreen
hi DiffChange           cterm=none            ctermfg=white            ctermbg=darkyellow
hi DiffRemove           cterm=none            ctermfg=white            ctermbg=darkred
hi Folded               cterm=none            ctermfg=white            ctermbg=darkgreen

hi StatusLineInsertMode cterm=underline       ctermfg=white            ctermbg=darkgreen
hi StatusLineNormalMode cterm=underline       ctermfg=white            ctermbg=darkyellow
hi StatusLineVisualMode cterm=underline       ctermfg=white            ctermbg=darkred

hi ExtraWhitespace                                                     ctermbg=darkred

"GUI Colors
hi Normal               gui=none              guifg=#f0f0f0            guibg=#0c0c0c
hi Scrollbar            gui=none              guifg=#55ffff            guibg=#008cff
hi VertSplit            gui=none              guifg=#50ff50            guibg=#202020
hi Menu                 gui=none              guifg=#0c0c0c            guibg=#55ffff
hi SpecialKey           gui=none              guifg=#ff3c3c
hi NonText              gui=none              guifg=#ff3c3c
hi Directory            gui=none              guifg=#aa5500
hi ErrorMsg             gui=bold              guifg=#f0f0f0            guibg=#ff3c3c
hi Search               gui=none              guifg=#f0f0f0            guibg=#aa5500
hi MoreMsg              gui=bold              guifg=#086008
hi ModeMsg              gui=bold              guifg=#f0f0f0            guibg=#5555ff
hi LineNr               gui=none              guifg=#50ff50            guibg=#151515
hi CursorLineNr         gui=none              guifg=#ffff30            guibg=#0c0c0c
hi ColorColumn                                                         guibg=#202020
hi Question             gui=bold              guifg=#086008
hi StatusLine           gui=underline         guifg=#f0f0f0            guibg=#0045ff
hi StatusLineNC         gui=underline         guifg=#f0f0f0            guibg=bg
hi Title                gui=bold              guifg=#a000a0
hi Visual               gui=none                                       guibg=#151515
hi WarningMsg           gui=bold              guifg=#550000
hi Cursor                                     guifg=bg                 guibg=#50ff50
hi Comment                                    guifg=#55ffff
hi Constant                                   guifg=#ff3c3c
hi String                                     guifg=#e64ce6
hi Special                                    guifg=#aa5500
hi Identifier           gui=none              guifg=#008cff
hi cEnumTag             gui=bold              guifg=#50ff50
hi cMemberTag           gui=bold              guifg=#50ff50
hi Statement            gui=none              guifg=#ffff30
hi Operator             gui=none              guifg=#ffff30
hi PreProc                                    guifg=#5555ff
hi Type                 gui=none              guifg=#50ff50
hi Error                                      guifg=#008cff            guibg=#0c0c0c
hi Todo                                       guifg=#008cff            guibg=bg
hi CursorLine           gui=none                                       guibg=#151515
hi CursorColumn                                                        guibg=#151515
hi MatchParen           gui=none              guifg=#ff3c3c            guibg=bg
hi TabLine              gui=underline         guifg=#f0f0f0            guibg=#101010
hi TabLineFill          gui=underline         guifg=#f0f0f0            guibg=#151515
hi TabLineSel           gui=underline         guifg=#f0f0f0            guibg=#5555ff
hi PMenu                                      guifg=#f0f0f0            guibg=#202020
hi PMenuSel             gui=bold              guifg=#f0f0f0            guibg=#086008
hi DiffAdd              gui=none              guifg=#f0f0f0            guibg=#086008
hi DiffChange           gui=none              guifg=#f0f0f0            guibg=#aa5500
hi DiffRemove           gui=none              guifg=#f0f0f0            guibg=#550000
hi Folded               gui=none              guifg=#f0f0f0            guibg=#086008

hi StatusLineInsertMode gui=underline         guifg=#f0f0f0            guibg=#086008
hi StatusLineNormalMode gui=underline         guifg=#f0f0f0            guibg=#aa5500
hi StatusLineVisualMode gui=underline         guifg=#f0f0f0            guibg=#550000

hi ExtraWhitespace                                                     guibg=#550000

hi link IncSearch       Visual
hi link Character       String
hi link Number          Constant
hi link Boolean         Keywoard
hi link Float           Number
hi link Function        Identifier
hi link Conditional     Statement
hi link Repeat          Statement
hi link Label           Statement
hi link Keyword         Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Class           Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link Delimiter       Special
hi link SpecialComment  Special
hi link Debug           Special
hi link DiffText        Normal

hi link TagbarComment              Comment
hi link TagbarKind                 Keyword
hi link TagbarNestedScope          Keyword
hi link TagbarScope                Type
hi link TagbarType                 Type
hi link TagbarSignature            Special
hi link TagbarPseudoID             PreProc
hi link TagbarFoldIcon             Operator
hi link TagbarHighlight            PMenuSel
hi link TagbarVisibilityPublic     Keyword
hi link TagbarVisibilityProtected  Keyword
hi link TagbarVisibilityPrivate    Keyword

hi link cTypeTag      Type
hi link cPreProcTag   PreProc
hi link cFunctionTag  Function
hi link cBoolean      Keyword

if exists("g:NERDChristmasTree") && g:NERDChristmasTree
	hi link NERDTreePart        Special
	hi link NERDTreePartFile    Type
	hi link NERDTreeFile        Normal
	hi link NERDTreeExecFile    Title
	hi link NERDTreeDirSlash    Identifier
	hi link NERDTreeClosable    Type
else
	hi link NERDTreePart        Normal
	hi link NERDTreePartFile    Normal
	hi link NERDTreeFile        Normal
	hi link NERDTreeClosable    Title
endif

hi link NERDTreeBookmarksHeader Statement
hi link NERDTreeBookmarksLeader Ignore
hi link NERDTreeBookmarkName    Identifier
hi link NERDTreeBookmark        Normal

hi link NERDTreeHelp            Comment
hi link NERDTreeHelpKey         Identifier
hi link NERDTreeHelpCommand     Identifier
hi link NERDTreeHelpTitle       Macro
hi link NERDTreeToggleOn        Question
hi link NERDTreeToggleOff       WarningMsg

hi link NERDTreeDir             Directory
hi link NERDTreeUp              Directory
hi link NERDTreeCWD             Statement
hi link NERDTreeLink            Macro
hi link NERDTreeOpenable        Title
hi link NERDTreeFlag            Ignore
hi link NERDTreeRO              WarningMsg
hi link NERDTreeBookmark        Statement

hi link NERDTreeCurrentNode     Search
