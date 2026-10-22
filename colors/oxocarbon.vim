" Name:    Oxocarbon vim colorscheme
" Author:  dylaris
" License: MIT
" Version: 1.0.0

" Global setup =============================================================={{

set background=dark
hi clear
syntax reset
let g:colors_name = 'oxocarbon'

if !exists('g:oxocarbon_italics')
  let g:oxocarbon_italics = 1
endif

if has('gui_running') || (exists('+termguicolors') && &termguicolors) ||
      \ &t_Co == 88 || &t_Co == 256
  " Utility functions -------------------------------------------------------{{{
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  fun <SID>color(r, g, b)
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        return <SID>grey_color(l:gx)
      else
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  fun <SID>X(group, fg, bg, attr)
    let l:attr = a:attr
    if g:oxocarbon_italics == 0 && l:attr ==? 'italic'
      let l:attr = 'none'
    endif

    if a:fg !=? ''
      exec 'hi ' . a:group . ' guifg=#' . a:fg . ' ctermfg=' . <SID>rgb(a:fg)
    endif
    if a:bg !=? ''
      exec 'hi ' . a:group . ' guibg=#' . a:bg . ' ctermbg=' . <SID>rgb(a:bg)
    endif
    if a:attr !=? ''
      exec 'hi ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
    endif
  endfun
  "}}}

  " Color definition --------------------------------------------------------{{{
  let s:bg          = '161616'
  let s:bg_alt      = '1f1f1f'
  let s:bg_highlight = '262626'
  let s:selection   = '393939'
  let s:border      = '525252'
  let s:comment     = '525252'
  let s:fg          = 'f2f4f8'
  let s:fg_muted    = 'dde1e6'
  let s:fg_subtle   = 'a8a8a8'
  let s:punctuation = 'a8a8a8'

  let s:red         = 'ee5396'
  let s:red_bright  = 'ff7eb6'
  let s:orange      = 'ff832b'
  let s:yellow      = 'f1c21b'
  let s:green       = '42be65'
  let s:green_bright = '08bdba'
  let s:cyan        = '3ddbd9'
  let s:blue        = '33b1ff'
  let s:blue_bright = '78a9ff'
  let s:purple      = 'be95ff'
  let s:magenta     = 'ff7eb6'
  let s:white       = 'ffffff'

  let g:terminal_color_0  = '#' . s:bg
  let g:terminal_color_1  = '#' . s:red
  let g:terminal_color_2  = '#' . s:green
  let g:terminal_color_3  = '#' . s:yellow
  let g:terminal_color_4  = '#' . s:blue_bright
  let g:terminal_color_5  = '#' . s:purple
  let g:terminal_color_6  = '#' . s:cyan
  let g:terminal_color_7  = '#' . s:fg_muted
  let g:terminal_color_8  = '#' . s:border
  let g:terminal_color_9  = '#' . s:red_bright
  let g:terminal_color_10 = '#' . s:green_bright
  let g:terminal_color_11 = '#' . s:magenta
  let g:terminal_color_12 = '#' . s:blue
  let g:terminal_color_13 = '#' . s:purple
  let g:terminal_color_14 = '#' . s:cyan
  let g:terminal_color_15 = '#' . s:white
  "}}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>X('bold',          '',               '',                   'bold')
  call <sid>X('ColorColumn',   '',               s:bg_highlight,       '')
  call <sid>X('Conceal',       s:comment,        '',                   '')
  call <sid>X('Cursor',        s:bg,             s:fg,                 '')
  call <sid>X('CursorIM',      '',               '',                   '')
  call <sid>X('CursorColumn',  '',               s:bg_alt,             '')
  call <sid>X('CursorLine',    '',               s:bg_alt,             '')
  call <sid>X('Directory',     s:blue,           '',                   '')
  call <sid>X('ErrorMsg',      s:red_bright,     s:bg,                 'none')
  call <sid>X('VertSplit',     s:selection,      '',                   'none')
  call <sid>X('Folded',        s:comment,        s:bg_alt,             '')
  call <sid>X('FoldColumn',    s:comment,        s:bg,                 '')
  call <sid>X('IncSearch',     s:bg,             s:cyan,               '')
  call <sid>X('LineNr',        s:comment,        '',                   '')
  call <sid>X('CursorLineNr',  s:purple,         s:bg_alt,             'bold')
  call <sid>X('MatchParen',    s:purple,         s:selection,          'bold')
  call <sid>X('Italic',        '',               '',                   'italic')
  call <sid>X('ModeMsg',       s:green,          '',                   '')
  call <sid>X('MoreMsg',       s:blue,           '',                   '')
  call <sid>X('NonText',       s:comment,        '',                   '')
  call <sid>X('PMenu',         s:fg_muted,       s:bg_highlight,       '')
  call <sid>X('PMenuSel',      s:bg,             s:blue,               'bold')
  call <sid>X('PMenuSbar',     '',               s:bg_alt,             '')
  call <sid>X('PMenuThumb',    '',               s:border,             '')
  call <sid>X('Question',      s:green,          '',                   '')
  call <sid>X('Search',        s:bg,             s:yellow,             '')
  call <sid>X('SpecialKey',    s:comment,        '',                   '')
  call <sid>X('StatusLine',    s:fg_muted,       s:bg_highlight,       'none')
  call <sid>X('StatusLineNC',  s:comment,        s:bg_alt,             'none')
  call <sid>X('TabLine',       s:comment,        s:bg,                 'none')
  call <sid>X('TabLineFill',   '',               s:bg,                 'none')
  call <sid>X('TabLineSel',    s:fg,             s:bg_highlight,       'bold')
  call <sid>X('Title',         s:red,            '',                   'bold')
  call <sid>X('Visual',        '',               s:selection,          '')
  call <sid>X('VisualNOS',     '',               s:selection,          '')
  call <sid>X('WarningMsg',    s:yellow,         '',                   '')
  call <sid>X('TooLong',       s:magenta,        '',                   '')
  call <sid>X('WildMenu',      s:bg,             s:blue,               '')
  call <sid>X('Normal',        s:fg,             s:bg,                 '')
  call <sid>X('SignColumn',    s:comment,        s:bg,                 '')
  call <sid>X('Special',       s:cyan,           '',                   '')

  " Modern Vim editor groups
  call <sid>X('NormalFloat',   s:fg,             s:bg_alt,             '')
  call <sid>X('FloatBorder',   s:border,         s:bg_alt,             '')
  call <sid>X('FloatTitle',    s:red,            s:bg_alt,             'bold')
  call <sid>X('WinSeparator',  s:selection,      '',                   'none')
  call <sid>X('QuickFixLine',  '',               s:bg_highlight,       '')
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>X('Comment',        s:comment,        '',          'italic')
  call <sid>X('Constant',       s:blue_bright,    '',          '')
  call <sid>X('String',         s:cyan,           '',          '')
  call <sid>X('Character',      s:cyan,           '',          '')
  call <sid>X('Number',         s:purple,         '',          '')
  call <sid>X('Boolean',        s:red,            '',          '')
  call <sid>X('Float',          s:purple,         '',          '')
  call <sid>X('Identifier',     s:fg,             '',          'none')
  call <sid>X('Function',       s:blue_bright,    '',          '')
  call <sid>X('Statement',      s:red,            '',          'none')
  call <sid>X('Conditional',    s:red,            '',          '')
  call <sid>X('Repeat',         s:red,            '',          '')
  call <sid>X('Label',          s:red,            '',          '')
  call <sid>X('Operator',       s:punctuation,    '',          'none')
  call <sid>X('Keyword',        s:red,            '',          '')
  call <sid>X('Exception',      s:red,            '',          '')
  call <sid>X('PreProc',        s:magenta,        '',          '')
  call <sid>X('Include',        s:red,            '',          '')
  call <sid>X('Define',         s:magenta,        '',          'none')
  call <sid>X('Macro',          s:magenta,        '',          '')
  call <sid>X('PreCondit',      s:magenta,        '',          '')
  call <sid>X('Type',           s:green_bright,   '',          'none')
  call <sid>X('StorageClass',   s:red,            '',          '')
  call <sid>X('Structure',      s:green_bright,   '',          '')
  call <sid>X('Typedef',        s:green_bright,   '',          '')
  call <sid>X('Special',        s:cyan,           '',          '')
  call <sid>X('SpecialChar',    s:orange,         '',          '')
  call <sid>X('Tag',            s:cyan,           '',          '')
  call <sid>X('Delimiter',      s:punctuation,    '',          '')
  call <sid>X('SpecialComment', s:comment,        '',          'italic')
  call <sid>X('Debug',          s:orange,         '',          '')
  call <sid>X('Underlined',     s:blue_bright,    '',          'underline')
  call <sid>X('Ignore',         s:comment,        '',          '')
  call <sid>X('Error',          s:red_bright,     s:bg,        'bold')
  call <sid>X('Todo',           s:yellow,         s:bg,        'bold')
  " }}}

  " Punctuation highlighting ------------------------------------------------{{{
  call <sid>X('oxocarbonPunctuation', s:punctuation, '', '')
  " }}}

  " C/C++ highlighting ------------------------------------------------------{{{
  call <sid>X('cComment',           s:comment,      '', 'italic')
  call <sid>X('cCommentL',          s:comment,      '', 'italic')
  call <sid>X('cCommentString',     s:comment,      '', 'italic')
  call <sid>X('cComment2String',    s:comment,      '', 'italic')
  call <sid>X('cTodo',              s:yellow,       s:bg, 'bold')
  call <sid>X('cString',            s:cyan,         '', '')
  call <sid>X('cCppString',         s:cyan,         '', '')
  call <sid>X('cCharacter',         s:cyan,         '', '')
  call <sid>X('cSpecialCharacter',  s:orange,       '', '')
  call <sid>X('cFormat',            s:orange,       '', '')
  call <sid>X('cNumber',            s:purple,       '', '')
  call <sid>X('cFloat',             s:purple,       '', '')
  call <sid>X('cOctal',             s:purple,       '', '')
  call <sid>X('cOctalZero',         s:purple,       '', '')
  call <sid>X('cNumbers',           s:purple,       '', '')
  call <sid>X('cConstant',          s:blue_bright,  '', '')
  call <sid>X('cBoolean',           s:red,          '', '')
  call <sid>X('cIdentifier',        s:fg,           '', '')
  call <sid>X('cFunction',          s:blue_bright,  '', '')
  call <sid>X('cFunctionPointer',   s:blue_bright,  '', '')
  call <sid>X('cStatement',         s:red,          '', '')
  call <sid>X('cConditional',       s:red,          '', '')
  call <sid>X('cRepeat',            s:red,          '', '')
  call <sid>X('cLabel',             s:red,          '', '')
  call <sid>X('cStorageClass',      s:red,          '', '')
  call <sid>X('cType',              s:green_bright, '', '')
  call <sid>X('Ctype',              s:green_bright, '', '')
  call <sid>X('cStructure',         s:green_bright, '', '')
  call <sid>X('cTypedef',           s:green_bright, '', '')
  call <sid>X('cOperator',          s:punctuation,  '', '')
  call <sid>X('cPreProc',           s:magenta,      '', '')
  call <sid>X('cInclude',           s:magenta,      '', '')
  call <sid>X('cPreCondit',         s:magenta,      '', '')
  call <sid>X('cPreConditMatch',    s:magenta,      '', '')
  call <sid>X('cDefine',            s:magenta,      '', '')
  call <sid>X('cPragma',            s:magenta,      '', '')
  call <sid>X('cSpecial',           s:cyan,         '', '')
  call <sid>X('cUserLabel',         s:red,          '', '')
  call <sid>X('cError',             s:red_bright,   s:bg, 'bold')
  " }}}

  " Rust highlighting -------------------------------------------------------{{{
  call <sid>X('rustCommentLine',             s:comment,      '', 'italic')
  call <sid>X('rustCommentLineDoc',          s:comment,      '', 'italic')
  call <sid>X('rustCommentBlock',            s:comment,      '', 'italic')
  call <sid>X('rustCommentBlockDoc',         s:comment,      '', 'italic')
  call <sid>X('rustTodo',                    s:yellow,       s:bg, 'bold')
  call <sid>X('rustString',                  s:cyan,         '', '')
  call <sid>X('rustStringDelimiter',         s:cyan,         '', '')
  call <sid>X('rustStringContinuation',      s:orange,       '', '')
  call <sid>X('rustCharacter',               s:cyan,         '', '')
  call <sid>X('rustEscape',                  s:orange,       '', '')
  call <sid>X('rustEscapeUnicode',           s:orange,       '', '')
  call <sid>X('rustNumber',                  s:purple,       '', '')
  call <sid>X('rustDecNumber',               s:purple,       '', '')
  call <sid>X('rustHexNumber',               s:purple,       '', '')
  call <sid>X('rustOctNumber',               s:purple,       '', '')
  call <sid>X('rustBinNumber',               s:purple,       '', '')
  call <sid>X('rustFloat',                   s:purple,       '', '')
  call <sid>X('rustBoolean',                 s:red,          '', '')
  call <sid>X('rustKeyword',                 s:red,          '', '')
  call <sid>X('rustReservedKeyword',         s:red,          '', '')
  call <sid>X('rustConditional',             s:red,          '', '')
  call <sid>X('rustRepeat',                  s:red,          '', '')
  call <sid>X('rustStorage',                 s:red,          '', '')
  call <sid>X('rustUnsafeKeyword',           s:red,          '', '')
  call <sid>X('rustFunction',                s:blue_bright,  '', '')
  call <sid>X('rustFuncName',                s:blue_bright,  '', '')
  call <sid>X('rustFuncCall',                s:blue_bright,  '', '')
  call <sid>X('rustType',                    s:green_bright, '', '')
  call <sid>X('rustTrait',                   s:green_bright, '', '')
  call <sid>X('rustEnum',                    s:green_bright, '', '')
  call <sid>X('rustStructure',               s:green_bright, '', '')
  call <sid>X('rustUnion',                   s:green_bright, '', '')
  call <sid>X('rustTypedef',                 s:green_bright, '', '')
  call <sid>X('rustEnumVariant',             s:blue_bright,  '', '')
  call <sid>X('rustMacro',                   s:magenta,      '', '')
  call <sid>X('rustMacroVariable',           s:magenta,      '', '')
  call <sid>X('rustAttribute',               s:magenta,      '', '')
  call <sid>X('rustDerive',                  s:magenta,      '', '')
  call <sid>X('rustDeriveTrait',             s:magenta,      '', '')
  call <sid>X('rustSelf',                    s:blue_bright,  '', '')
  call <sid>X('rustLabel',                   s:red,          '', '')
  call <sid>X('rustLifetime',                s:orange,       '', '')
  call <sid>X('rustOperator',                s:punctuation,  '', '')
  call <sid>X('rustArrowCharacter',          s:punctuation,  '', '')
  call <sid>X('rustQuestionMark',            s:punctuation,  '', '')
  call <sid>X('rustSigil',                   s:punctuation,  '', '')
  call <sid>X('rustModPathSep',              s:punctuation,  '', '')
  call <sid>X('rustMacroRepeatDelimiters',   s:punctuation,  '', '')
  call <sid>X('rustAssert',                  s:magenta,      '', '')
  call <sid>X('rustPanic',                   s:magenta,      '', '')
  call <sid>X('rustCommentLineDocError',     s:red_bright,   s:bg, 'bold')
  call <sid>X('rustCommentBlockDocError',    s:red_bright,   s:bg, 'bold')
  call <sid>X('rustEscapeError',             s:red_bright,   s:bg, 'bold')
  " }}}

  " Lua highlighting --------------------------------------------------------{{{
  call <sid>X('luaComment',           s:comment,      '', 'italic')
  call <sid>X('luaCommentDelimiter',  s:comment,      '', 'italic')
  call <sid>X('luaTodo',              s:yellow,       s:bg, 'bold')
  call <sid>X('luaString',            s:cyan,         '', '')
  call <sid>X('luaString2',           s:cyan,         '', '')
  call <sid>X('luaStringDelimiter',   s:cyan,         '', '')
  call <sid>X('luaSpecial',           s:orange,       '', '')
  call <sid>X('luaNumber',            s:purple,       '', '')
  call <sid>X('luaConstant',          s:blue_bright,  '', '')
  call <sid>X('luaStatement',         s:red,          '', '')
  call <sid>X('luaCond',              s:red,          '', '')
  call <sid>X('luaCondElse',          s:red,          '', '')
  call <sid>X('luaRepeat',            s:red,          '', '')
  call <sid>X('luaFor',               s:red,          '', '')
  call <sid>X('luaFunction',          s:red,          '', '')
  call <sid>X('luaFunc',              s:blue_bright,  '', '')
  call <sid>X('luaMetaMethod',        s:blue_bright,  '', '')
  call <sid>X('luaLabel',             s:red,          '', '')
  call <sid>X('luaTable',             s:green_bright, '', '')
  call <sid>X('luaOperator',          s:punctuation,  '', '')
  call <sid>X('luaSymbolOperator',    s:punctuation,  '', '')
  call <sid>X('luaError',             s:red_bright,   s:bg, 'bold')
  call <sid>X('luaParenError',        s:red_bright,   s:bg, 'bold')
  " }}}

  " HTML highlighting -------------------------------------------------------{{{
  call <sid>X('htmlComment',          s:comment,      '', 'italic')
  call <sid>X('htmlTag',              s:punctuation,  '', '')
  call <sid>X('htmlEndTag',           s:punctuation,  '', '')
  call <sid>X('htmlScriptTag',        s:punctuation,  '', '')
  call <sid>X('htmlTagName',          s:red,          '', '')
  call <sid>X('htmlSpecialTagName',   s:red_bright,   '', 'bold')
  call <sid>X('htmlArg',              s:green_bright, '', '')
  call <sid>X('htmlValue',            s:cyan,         '', '')
  call <sid>X('htmlString',           s:cyan,         '', '')
  call <sid>X('htmlSpecialChar',      s:orange,       '', '')
  call <sid>X('htmlEvent',            s:orange,       '', '')
  call <sid>X('htmlLink',             s:blue_bright,  '', 'underline')
  call <sid>X('htmlTitle',            s:blue_bright,  '', 'bold')
  call <sid>X('htmlH1',               s:red,          '', 'bold')
  call <sid>X('htmlH2',               s:orange,       '', 'bold')
  call <sid>X('htmlH3',               s:yellow,       '', 'bold')
  call <sid>X('htmlH4',               s:green,        '', 'bold')
  call <sid>X('htmlH5',               s:cyan,         '', 'bold')
  call <sid>X('htmlH6',               s:purple,       '', 'bold')
  call <sid>X('htmlBold',             '',             '', 'bold')
  call <sid>X('htmlItalic',           '',             '', 'italic')
  call <sid>X('htmlUnderline',        '',             '', 'underline')
  call <sid>X('htmlStrike',           '',             '', 'strikethrough')
  call <sid>X('htmlCssDefinition',    s:magenta,      '', '')
  call <sid>X('htmlCssStyleComment',  s:comment,      '', 'italic')
  call <sid>X('htmlStyleArg',         s:cyan,         '', '')
  call <sid>X('htmlError',            s:red_bright,   s:bg, 'bold')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  call <sid>X('javaScriptComment',          s:comment,      '', 'italic')
  call <sid>X('javaScriptLineComment',      s:comment,      '', 'italic')
  call <sid>X('javaScriptCommentTodo',      s:yellow,       s:bg, 'bold')
  call <sid>X('javaScriptStringS',          s:cyan,         '', '')
  call <sid>X('javaScriptStringD',          s:cyan,         '', '')
  call <sid>X('javaScriptStringT',          s:cyan,         '', '')
  call <sid>X('javaScriptRegexpString',     s:cyan,         '', '')
  call <sid>X('javaScriptSpecial',          s:orange,       '', '')
  call <sid>X('javaScriptSpecialCharacter', s:orange,       '', '')
  call <sid>X('javaScriptNumber',           s:purple,       '', '')
  call <sid>X('javaScriptConditional',      s:red,          '', '')
  call <sid>X('javaScriptRepeat',           s:red,          '', '')
  call <sid>X('javaScriptBranch',           s:red,          '', '')
  call <sid>X('javaScriptOperator',         s:punctuation,  '', '')
  call <sid>X('javaScriptBraces',           s:punctuation,  '', '')
  call <sid>X('javaScriptParens',           s:punctuation,  '', '')
  call <sid>X('javaScriptType',             s:green_bright, '', '')
  call <sid>X('javaScriptStatement',        s:red,          '', '')
  call <sid>X('javaScriptBoolean',          s:red,          '', '')
  call <sid>X('javaScriptNull',             s:red,          '', '')
  call <sid>X('javaScriptIdentifier',       s:red_bright,   '', '')
  call <sid>X('javaScriptFunction',         s:red,          '', '')
  call <sid>X('javaScriptLabel',            s:red,          '', '')
  call <sid>X('javaScriptException',        s:red,          '', '')
  call <sid>X('javaScriptReserved',         s:red,          '', '')
  call <sid>X('javaScriptModifier',         s:red,          '', '')
  call <sid>X('javaScriptMessage',          s:blue_bright,  '', '')
  call <sid>X('javaScriptGlobal',           s:blue_bright,  '', '')
  call <sid>X('javaScriptMember',           s:blue_bright,  '', '')
  call <sid>X('javaScriptConstant',         s:blue_bright,  '', '')
  call <sid>X('javaScriptDeprecated',       s:orange,       '', '')
  call <sid>X('javaScriptDebug',            s:orange,       '', '')
  call <sid>X('javaScriptError',            s:red_bright,   s:bg, 'bold')
  " }}}

  " CSS highlighting --------------------------------------------------------{{{
  call <sid>X('cssComment',             s:comment,      '', 'italic')
  call <sid>X('cssTagName',             s:red,          '', '')
  call <sid>X('cssClassName',           s:blue_bright,  '', '')
  call <sid>X('cssClassNameDot',        s:punctuation,  '', '')
  call <sid>X('cssIdentifier',          s:magenta,      '', '')
  call <sid>X('cssSelectorOp',          s:punctuation,  '', '')
  call <sid>X('cssSelectorOp2',         s:punctuation,  '', '')
  call <sid>X('cssPseudoClass',         s:blue_bright,  '', '')
  call <sid>X('cssPseudoClassFn',       s:blue_bright,  '', '')
  call <sid>X('cssPseudoClassId',       s:blue_bright,  '', '')
  call <sid>X('cssAtRule',              s:red,          '', '')
  call <sid>X('cssAtRuleLogical',       s:red,          '', '')
  call <sid>X('cssAtKeyword',           s:magenta,      '', '')
  call <sid>X('cssImportant',           s:red_bright,   '', 'bold')
  call <sid>X('cssCustomProp',          s:blue_bright,  '', '')
  call <sid>X('cssFunction',            s:blue_bright,  '', '')
  call <sid>X('cssFunctionComma',       s:punctuation,  '', '')
  call <sid>X('cssAttrComma',           s:punctuation,  '', '')
  call <sid>X('cssBraces',              s:punctuation,  '', '')
  call <sid>X('cssNoise',               s:punctuation,  '', '')
  call <sid>X('cssStringQ',             s:cyan,         '', '')
  call <sid>X('cssStringQQ',            s:cyan,         '', '')
  call <sid>X('cssSpecialCharQ',        s:orange,       '', '')
  call <sid>X('cssSpecialCharQQ',       s:orange,       '', '')
  call <sid>X('cssURL',                 s:cyan,         '', 'underline')
  call <sid>X('cssColor',               s:yellow,       '', '')
  call <sid>X('cssProp',                s:blue_bright,  '', '')
  call <sid>X('cssColorProp',           s:blue_bright,  '', '')
  call <sid>X('cssBackgroundProp',      s:blue_bright,  '', '')
  call <sid>X('cssBorderProp',          s:blue_bright,  '', '')
  call <sid>X('cssBoxProp',             s:blue_bright,  '', '')
  call <sid>X('cssTextProp',            s:blue_bright,  '', '')
  call <sid>X('cssFontProp',            s:blue_bright,  '', '')
  call <sid>X('cssTransitionProp',      s:blue_bright,  '', '')
  call <sid>X('cssAnimationProp',       s:blue_bright,  '', '')
  call <sid>X('cssPositioningProp',     s:blue_bright,  '', '')
  call <sid>X('cssFlexibleBoxProp',     s:blue_bright,  '', '')
  call <sid>X('cssGridProp',            s:blue_bright,  '', '')
  call <sid>X('cssTableProp',           s:blue_bright,  '', '')
  call <sid>X('cssColumnProp',          s:blue_bright,  '', '')
  call <sid>X('cssUnitDecorators',      s:orange,       '', '')
  call <sid>X('cssValueNumber',         s:purple,       '', '')
  call <sid>X('cssValueLength',         s:purple,       '', '')
  call <sid>X('cssValueAngle',          s:purple,       '', '')
  call <sid>X('cssValueTime',           s:purple,       '', '')
  call <sid>X('cssValueFrequency',      s:purple,       '', '')
  call <sid>X('cssUnicodeEscape',       s:orange,       '', '')
  call <sid>X('cssMediaType',           s:red,          '', '')
  call <sid>X('cssVendor',              s:comment,      '', '')
  call <sid>X('cssHacks',               s:comment,      '', '')
  call <sid>X('cssError',               s:red_bright,   s:bg, 'bold')
  call <sid>X('cssBraceError',          s:red_bright,   s:bg, 'bold')
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  call <sid>X('markdownH1',                    s:red,          '', 'bold')
  call <sid>X('markdownH2',                    s:orange,       '', 'bold')
  call <sid>X('markdownH3',                    s:yellow,       '', 'bold')
  call <sid>X('markdownH4',                    s:green,        '', 'bold')
  call <sid>X('markdownH5',                    s:cyan,         '', 'bold')
  call <sid>X('markdownH6',                    s:purple,       '', 'bold')
  call <sid>X('markdownHeadingDelimiter',      s:punctuation,  '', '')
  call <sid>X('markdownHeadingRule',           s:punctuation,  '', '')
  call <sid>X('markdownRule',                  s:punctuation,  '', '')
  call <sid>X('markdownBlockquote',            s:comment,      '', 'italic')
  call <sid>X('markdownListMarker',            s:orange,       '', '')
  call <sid>X('markdownOrderedListMarker',     s:orange,       '', '')
  call <sid>X('markdownCode',                  s:cyan,         s:bg_alt, '')
  call <sid>X('markdownCodeBlock',             s:fg_muted,     s:bg_alt, '')
  call <sid>X('markdownCodeDelimiter',         s:punctuation,  '', '')
  call <sid>X('markdownLinkText',              s:blue_bright,  '', 'underline')
  call <sid>X('markdownLinkTextDelimiter',     s:punctuation,  '', '')
  call <sid>X('markdownLinkDelimiter',         s:punctuation,  '', '')
  call <sid>X('markdownIdDelimiter',           s:punctuation,  '', '')
  call <sid>X('markdownUrlDelimiter',          s:punctuation,  '', '')
  call <sid>X('markdownUrlTitleDelimiter',     s:punctuation,  '', '')
  call <sid>X('markdownUrl',                   s:cyan,         '', 'underline')
  call <sid>X('markdownUrlTitle',              s:cyan,         '', '')
  call <sid>X('markdownAutomaticLink',         s:cyan,         '', 'underline')
  call <sid>X('markdownId',                    s:green_bright, '', '')
  call <sid>X('markdownIdDeclaration',         s:green_bright, '', '')
  call <sid>X('markdownItalic',                '',             '', 'italic')
  call <sid>X('markdownItalicDelimiter',       s:punctuation,  '', '')
  call <sid>X('markdownBold',                  '',             '', 'bold')
  call <sid>X('markdownBoldDelimiter',         s:punctuation,  '', '')
  call <sid>X('markdownBoldItalic',            '',             '', 'bold')
  call <sid>X('markdownBoldItalicDelimiter',   s:punctuation,  '', '')
  call <sid>X('markdownStrike',                '',             '', 'strikethrough')
  call <sid>X('markdownStrikeDelimiter',       s:punctuation,  '', '')
  call <sid>X('markdownEscape',                s:orange,       '', '')
  call <sid>X('markdownFootnote',              s:green_bright, '', '')
  call <sid>X('markdownFootnoteDefinition',    s:green_bright, '', '')
  call <sid>X('markdownError',                 s:red_bright,   s:bg, 'bold')
  " }}}

  " Vimscript highlighting --------------------------------------------------{{{
  call <sid>X('vimComment',                s:comment,      '', 'italic')
  call <sid>X('vim9Comment',               s:comment,      '', 'italic')
  call <sid>X('vimCommentTitle',           s:magenta,      '', 'italic')
  call <sid>X('vim9CommentTitle',          s:magenta,      '', 'italic')
  call <sid>X('vimTodo',                   s:yellow,       s:bg, 'bold')
  call <sid>X('vimCommand',                s:red,          '', '')
  call <sid>X('vimFunction',               s:red,          '', '')
  call <sid>X('vimDef',                    s:red,          '', '')
  call <sid>X('vimFuncName',               s:blue_bright,  '', '')
  call <sid>X('vimFunctionName',           s:blue_bright,  '', '')
  call <sid>X('vimUserFunc',               s:blue_bright,  '', '')
  call <sid>X('vim9UserFunc',              s:blue_bright,  '', '')
  call <sid>X('vimString',                 s:cyan,         '', '')
  call <sid>X('vimStringEnd',              s:cyan,         '', '')
  call <sid>X('vimStringCont',             s:cyan,         '', '')
  call <sid>X('vimContinueString',         s:cyan,         '', '')
  call <sid>X('vimNumber',                 s:purple,       '', '')
  call <sid>X('vimOper',                   s:punctuation,  '', '')
  call <sid>X('vimOperParen',              s:punctuation,  '', '')
  call <sid>X('vimBracket',                s:punctuation,  '', '')
  call <sid>X('vimSep',                    s:punctuation,  '', '')
  call <sid>X('vimSearchDelim',            s:punctuation,  '', '')
  call <sid>X('vimSubstDelim',             s:punctuation,  '', '')
  call <sid>X('vimStringInterpolationBrace', s:punctuation, '', '')
  call <sid>X('vimOption',                 s:blue_bright,  '', '')
  call <sid>X('vimEnvvar',                 s:magenta,      '', '')
  call <sid>X('vimVar',                    s:blue_bright,  '', '')
  call <sid>X('vim9Variable',              s:blue_bright,  '', '')
  call <sid>X('vimVarScope',               s:purple,       '', '')
  call <sid>X('vimType',                   s:green_bright, '', '')
  call <sid>X('vim9Type',                  s:green_bright, '', '')
  call <sid>X('vim9VariableType',          s:green_bright, '', '')
  call <sid>X('vim9UserType',              s:green_bright, '', '')
  call <sid>X('vimHiGroup',                s:blue_bright,  '', '')
  call <sid>X('vimNotation',               s:orange,       '', '')
  call <sid>X('vimEscape',                 s:orange,       '', '')
  call <sid>X('vim9EnumValueListComma',    s:punctuation,  '', '')
  call <sid>X('vim9TypeEquals',            s:punctuation,  '', '')
  call <sid>X('vimError',                  s:red_bright,   s:bg, 'bold')
  call <sid>X('vim9CommentError',          s:red_bright,   s:bg, 'bold')
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  call <sid>X('goComment',                  s:comment,      '', 'italic')
  call <sid>X('goTodo',                     s:yellow,       s:bg, 'bold')
  call <sid>X('goString',                   s:cyan,         '', '')
  call <sid>X('goRawString',                s:cyan,         '', '')
  call <sid>X('goImportString',             s:cyan,         '', '')
  call <sid>X('goCharacter',                s:cyan,         '', '')
  call <sid>X('goEscapeC',                  s:orange,       '', '')
  call <sid>X('goEscapeOctal',              s:orange,       '', '')
  call <sid>X('goEscapeX',                  s:orange,       '', '')
  call <sid>X('goEscapeU',                  s:orange,       '', '')
  call <sid>X('goEscapeBigU',               s:orange,       '', '')
  call <sid>X('goDecimalInt',               s:purple,       '', '')
  call <sid>X('goHexadecimalInt',           s:purple,       '', '')
  call <sid>X('goOctalInt',                 s:purple,       '', '')
  call <sid>X('goBinaryInt',                s:purple,       '', '')
  call <sid>X('goFloat',                    s:purple,       '', '')
  call <sid>X('goHexadecimalFloat',         s:purple,       '', '')
  call <sid>X('goComplexes',                s:purple,       '', '')
  call <sid>X('goBoolean',                  s:red,          '', '')
  call <sid>X('goPredefinedIdentifiers',    s:blue_bright,  '', '')
  call <sid>X('goPackage',                  s:red,          '', '')
  call <sid>X('goImport',                   s:red,          '', '')
  call <sid>X('goDeclaration',              s:red,          '', '')
  call <sid>X('goVar',                      s:red,          '', '')
  call <sid>X('goConst',                    s:red,          '', '')
  call <sid>X('goStatement',                s:red,          '', '')
  call <sid>X('goConditional',              s:red,          '', '')
  call <sid>X('goLabel',                    s:red,          '', '')
  call <sid>X('goRepeat',                   s:red,          '', '')
  call <sid>X('goFunction',                 s:blue_bright,  '', '')
  call <sid>X('goFunctionCall',             s:blue_bright,  '', '')
  call <sid>X('goBuiltins',                 s:blue_bright,  '', '')
  call <sid>X('goType',                     s:green_bright, '', '')
  call <sid>X('goExtraType',                s:green_bright, '', '')
  call <sid>X('goReceiverType',             s:green_bright, '', '')
  call <sid>X('goTypeName',                 s:green_bright, '', '')
  call <sid>X('goTypeConstructor',          s:green_bright, '', '')
  call <sid>X('goField',                    s:cyan,         '', '')
  call <sid>X('goOperator',                 s:punctuation,  '', '')
  call <sid>X('goPointerOperator',          s:punctuation,  '', '')
  call <sid>X('goVarArgs',                  s:punctuation,  '', '')
  call <sid>X('goSpaceError',               s:red_bright,   s:bg, 'bold')
  " }}}

  " Perl highlighting -------------------------------------------------------{{{
  call <sid>X('perlComment',                s:comment,      '', 'italic')
  call <sid>X('perlPOD',                    s:comment,      '', 'italic')
  call <sid>X('perlTodo',                   s:yellow,       s:bg, 'bold')
  call <sid>X('perlString',                 s:cyan,         '', '')
  call <sid>X('perlStringUnexpanded',       s:cyan,         '', '')
  call <sid>X('perlHereDoc',                s:cyan,         '', '')
  call <sid>X('perlIndentedHereDoc',        s:cyan,         '', '')
  call <sid>X('perlShellCommand',           s:cyan,         '', '')
  call <sid>X('perlSpecialString',          s:orange,       '', '')
  call <sid>X('perlSpecialStringU',         s:orange,       '', '')
  call <sid>X('perlSpecialStringU2',        s:orange,       '', '')
  call <sid>X('perlSpecialMatch',           s:orange,       '', '')
  call <sid>X('perlNumber',                 s:purple,       '', '')
  call <sid>X('perlFloat',                  s:purple,       '', '')
  call <sid>X('perlStatement',              s:red,          '', '')
  call <sid>X('perlConditional',            s:red,          '', '')
  call <sid>X('perlRepeat',                 s:red,          '', '')
  call <sid>X('perlOperator',               s:punctuation,  '', '')
  call <sid>X('perlControl',                s:magenta,      '', '')
  call <sid>X('perlInclude',                s:red,          '', '')
  call <sid>X('perlFunction',               s:red,          '', '')
  call <sid>X('perlSubName',                s:blue_bright,  '', '')
  call <sid>X('perlSubPrototype',           s:green_bright, '', '')
  call <sid>X('perlSubSignature',           s:green_bright, '', '')
  call <sid>X('perlSubAttribute',           s:magenta,      '', '')
  call <sid>X('perlPackageDecl',            s:green_bright, '', '')
  call <sid>X('perlPackageRef',             s:green_bright, '', '')
  call <sid>X('perlType',                   s:green_bright, '', '')
  call <sid>X('perlVarPlain',               s:blue_bright,  '', '')
  call <sid>X('perlVarPlain2',              s:blue_bright,  '', '')
  call <sid>X('perlVarSimpleMember',        s:blue_bright,  '', '')
  call <sid>X('perlVarSimpleMemberName',    s:cyan,         '', '')
  call <sid>X('perlIdentifier',             s:fg,           '', '')
  call <sid>X('perlLabel',                  s:red,          '', '')
  call <sid>X('perlSpecial',                s:orange,       '', '')
  call <sid>X('perlMatch',                  s:cyan,         '', '')
  call <sid>X('perlQ',                      s:cyan,         '', '')
  call <sid>X('perlQQ',                     s:cyan,         '', '')
  call <sid>X('perlQW',                     s:cyan,         '', '')
  call <sid>X('perlQR',                     s:cyan,         '', '')
  call <sid>X('perlPostDeref',              s:punctuation,  '', '')
  call <sid>X('perlNotEmptyLine',           s:red_bright,   s:bg, 'bold')
  call <sid>X('perlElseIfError',            s:red_bright,   s:bg, 'bold')
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  call <sid>X('DiffAdd',     s:green,          s:bg_alt, '')
  call <sid>X('DiffChange',  s:yellow,         s:bg_alt, '')
  call <sid>X('DiffDelete',  s:red,            s:bg_alt, '')
  call <sid>X('DiffText',    s:bg,             s:yellow, 'bold')
  call <sid>X('DiffAdded',   s:green,          '',       '')
  call <sid>X('DiffChanged', s:yellow,         '',       '')
  call <sid>X('DiffRemoved', s:red,            '',       '')
  call <sid>X('DiffFile',    s:blue,           '',       '')
  call <sid>X('DiffLine',    s:comment,        '',       '')
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  call <sid>X('SpellBad',   s:red_bright,  '', 'undercurl')
  call <sid>X('SpellLocal', s:yellow,      '', 'undercurl')
  call <sid>X('SpellCap',   s:blue_bright, '', 'undercurl')
  call <sid>X('SpellRare',  s:purple,      '', 'undercurl')
  " }}}

  " Punctuation syntax ------------------------------------------------------{{{
  function! OxocarbonPunctuationApply() abort
    let l:filetypes = [
          \ 'c', 'cpp', 'rust', 'lua', 'html', 'javascript',
          \ 'javascriptreact', 'css', 'markdown', 'vim', 'go', 'perl'
          \ ]

    if index(l:filetypes, &filetype) < 0
      return
    endif

    silent! syntax clear oxocarbonPunctuation
    " syntax match oxocarbonPunctuation /[,+{}()\[\];:=<>!&|^~?*\/%.-]/ display
    syntax match oxocarbonPunctuation /[,{}()\[\];]/ display
  endfunction

  augroup oxocarbon_punctuation
    autocmd!
    autocmd Syntax * call OxocarbonPunctuationApply()
    autocmd ColorSchemePre * autocmd! oxocarbon_punctuation |
          \ silent! syntax clear oxocarbonPunctuation
  augroup END

  if exists('b:current_syntax')
    call OxocarbonPunctuationApply()
  endif
  " }}}

" Delete functions =========================================================={{
  delf <SID>X
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
"}}}

endif
"}}}


" vim: set fdl=0 fdm=marker:
