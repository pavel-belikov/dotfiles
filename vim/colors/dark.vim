hi clear
set background=dark
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "dark"

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
hi LineNr                                     ctermfg=green            ctermbg=lightgray
hi CursorLineNr                               ctermfg=yellow           ctermbg=black
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
hi Identifier                                 ctermfg=darkcyan
hi cEnumTag             cterm=bold            ctermfg=lightgreen
hi cMemberTag           cterm=bold            ctermfg=lightgreen
hi Statement            cterm=none            ctermfg=yellow
hi Operator             cterm=bold            ctermfg=yellow
hi PreProc                                    ctermfg=blue
hi Type                                       ctermfg=green
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
"hi PmenuSel             cterm=bold,underline  ctermfg=lightgreen       ctermbg=lightgrey
hi DiffAdd              cterm=none            ctermfg=white            ctermbg=darkgreen
hi DiffChange           cterm=none            ctermfg=white            ctermbg=darkyellow
hi DiffRemove           cterm=none            ctermfg=white            ctermbg=darkred
hi Folded               cterm=none            ctermfg=white            ctermbg=darkgreen

hi StatusLineInsertMode cterm=underline       ctermfg=white            ctermbg=darkgreen
hi StatusLineNormalMode cterm=underline       ctermfg=white            ctermbg=darkyellow
hi StatusLineVisualMode cterm=underline       ctermfg=white            ctermbg=darkred

hi ExtraWhitespace ctermbg=darkred

"TODO: PMenuSbar PMenuThumb
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
