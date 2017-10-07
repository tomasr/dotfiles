"==================================================
" File:         VimExplorer.vim
" Brief:        VE - the File Manager within Vim!
" Authors:      Ming Bai <mbbill AT gmail DOT com>
" Last Change:  2007-08-08 15:17:46
" Version:      0.98
" Licence:      LGPL
"
" Usage:        :h VimExplorer
"
"==================================================


" Vim version 7.x is needed.
if v:version < 700
     echohl ErrorMsg | echomsg "VimExplorer needs vim version >= 7.0!" | echohl None
     finish
endif

" See if we are already loaded, thanks to Dennis Hostetler.
if exists("loaded_vimExplorer")
    finish
else
    let loaded_vimExplorer = 1
endif
"

"Load config {{{1
"#######################################################################
"VimExplorer configuration.
"
let VEConf = {}

"Normal configurations.

"Common settings
"==========================================

"Important! It is used to do iconv() to the path when calling
"sytem() function.  Mine is Simplified Chinese (cp936).
if exists("g:VEConf_systemEncoding")
    let VEConf.systemEncoding = g:VEConf_systemEncoding
else
    let VEConf.systemEncoding = ''
endif

"VimExplorer will check all the disks in this list at startup.
"Delete some of these to fit your system can increase start up
"speed.
"let VEConf.win32Disks = ["C:","D:","E:"]
if exists("g:VEConf_win32Disks")
    let VEConf.win32Disks = g:VEConf_win32Disks
else
    let VEConf.win32Disks = ["A:","B:","C:","D:","E:","F:","G:","H:",
                \"I:","J:","K:","L:","M:","N:","O:","P:","Q:","R:",
                \"S:","T:","U:","V:","W:","X:","Y:","Z:"]
endif

"Set the forward and backward history stack depth.
if exists("g:VEConf_browseHistory")
    let VEConf.browseHistory = g:VEConf_browseHistory
else
    let VEConf.browseHistory = 100
endif

"Split location of preview window
if exists("g:VEConf_previewSplitLocation")
    let VEConf.previewSplitLocation = g:VEConf_previewSplitLocation
else
    let VEConf.previewSplitLocation = "belowright"
endif

"Show hidden files ( .* )
if exists("g:VEConf_showHiddenFiles")
    let VEConf.showHiddenFiles = VEConf_showHiddenFiles
else
    let VEConf.showHiddenFiles = 1
endif

"External explorer name
if (has("win32") || has("win95") || has("win64") || has("win16"))
    if exists("g:VEConf_externalExplorer")
        let VEConf.externalExplorer = g:VEConf_externalExplorer
    else
        let VEConf.externalExplorer = "explorer.exe"
    endif
else
    if exists("g:VEConf_externalExplorer")
        let VEConf.externalExplorer = g:VEConf_externalExplorer
    else
        let VEConf.externalExplorer = "nautilus"
    endif
endif

"Sort case sensitive , for everything
if exists("g:VEConf_sortCaseSensitive")
    let VEConf.sortCaseSensitive = g:VEConf_sortCaseSensitive
else
    let VEConf.sortCaseSensitive = 0
endif

"favorite file name
if exists("g:VEConf_favorite")
    let VEConf.favorite = g:VEConf_favorite
else
    let VEConf.favorite = ".ve_favorite"
endif

"Overwrite existing files.
"boverWrite 0 ask, 1 allyes, 2 allno
if exists("g:VEConf_overWriteExisting")
    let VEConf.overWriteExisting = g:VEConf_overWriteExisting
else
    let VEConf.overWriteExisting = 0
endif

"Kde or gonme.
if !exists("g:VEConf_usingKDE")
    let g:VEConf_usingKDE = 0
endif
if !exists("g:VEConf_usingGnome")
    let g:VEConf_usingGnome = 0
endif

"Tree panel settings
"==========================================

"Don't show '+' before empty folders.
"It will cause a little performance lost.
if exists("g:VEConf_showFolderStatus")
    let VEConf.showFolderStatus = g:VEConf_showFolderStatus
else
    let VEConf.showFolderStatus = 1
endif

"Tree panel width
if exists("g:VEConf_treePanelWidth")
    let VEConf.treePanelWidth = g:VEConf_treePanelWidth
else
    let VEConf.treePanelWidth = 30
endif

"Split mode of tree panel
if exists("g:VEConf_treePanelSplitMode")
    let VEConf.treePanelSplitMode = g:VEConf_treePanelSplitMode
else
    let VEConf.treePanelSplitMode = "vertical"
endif

"Split location of file panel
if exists("g:VEConf_treePanelSplitLocation")
    let VEConf.treePanelSplitLocation = g:VEConf_treePanelSplitLocation
else
    let VEConf.treePanelSplitLocation = "leftabove"
endif

"Set the tree panel sort direction.
if exists("g:VEConf_treeSortDirection")
    let VEConf.treeSortDirection = g:VEConf_treeSortDirection
else
    let VEConf.treeSortDirection = 1
endif

"File panel settings
"==========================================

"Set the file group sort direction.
if exists("g:VEConf_fileGroupSortDirection")
    let VEConf.fileGroupSortDirection = g:VEConf_fileGroupSortDirection
else
    let VEConf.fileGroupSortDirection = 1
endif

"Delete file confirm.
if exists("g:VEConf_fileDeleteConfirm")
    let VEConf.fileDeleteConfirm = g:VEConf_fileDeleteConfirm
else
    let VEConf.fileDeleteConfirm = 1
endif

"File panel width
if exists("g:VEConf_filePanelWidth")
    let VEConf.filePanelWidth = g:VEConf_filePanelWidth
else
    let VEConf.filePanelWidth = 40
endif

"Split mode of file panel
if exists("g:VEConf_filePanelSplitMode")
    let VEConf.filePanelSplitMode = g:VEConf_filePanelSplitMode
else
    let VEConf.filePanelSplitMode = "vertical"
endif

"Split location of file panel
if exists("g:VEConf_filePanelSplitLocation")
    let VEConf.filePanelSplitLocation = g:VEConf_filePanelSplitLocation
else
    let VEConf.filePanelSplitLocation = "belowright"
endif

"File panel sort type.
if exists("g:VEConf_filePanelSortType")
    let VEConf.filePanelSortType = g:VEConf_filePanelSortType
else
    let VEConf.filePanelSortType = 0
endif

"Show file size in M/K/B
if exists("g:VEConf_showFileSizeInMKB")
    let VEConf.showFileSizeInMKB = g:VEConf_showFileSizeInMKB
else
    let VEConf.showFileSizeInMKB = 1
endif

"File panel filter.
if exists("g:VEConf_filePanelFilter")
    let VEConf.filePanelFilter = g:VEConf_filePanelFilter
else
    let VEConf.filePanelFilter = ''
endif


"#######################################################################
"Tree panel hot key bindings.
let VEConf.treePanelHotkey = {}
let VEConf.treePanelHotkey.help            = '?'
let VEConf.treePanelHotkey.toggleNode      = '<cr>'
let VEConf.treePanelHotkey.toggleNodeMouse = '<2-LeftMouse>'
let VEConf.treePanelHotkey.refresh         = 'r'
let VEConf.treePanelHotkey.favorite        = 'f'
let VEConf.treePanelHotkey.addToFavorite   = 'F'
let VEConf.treePanelHotkey.browseHistory   = 'b'
let VEConf.treePanelHotkey.toggleFilePanel = 't'
let VEConf.treePanelHotkey.toUpperDir      = '<bs>'
let VEConf.treePanelHotkey.switchPanel     = '<c-tab>'
let VEConf.treePanelHotkey.gotoPath        = '<c-g>'
let VEConf.treePanelHotkey.quitVE          = 'Q'

if exists("g:VEConf_treeHotkey")
    if type(g:VEConf_treeHotkey) != type({})
        echohl WarningMsg | echo "g:VEConf_treeHotkey is not dictionary type!" | echohl None
        finish
    endif
    for i in keys(g:VEConf_treeHotkey)
        let VEConf.treePanelHotkey[i] = g:VEConf_treeHotkey[i]
    endfor
endif

"File panel hot key bindings.
"normal mode hotkeys
let VEConf.filePanelHotkey = {}
"normal
let VEConf.filePanelHotkey.help            = '?'
let VEConf.filePanelHotkey.itemClicked     = '<cr>'
let VEConf.filePanelHotkey.itemClickMouse  = '<2-LeftMouse>'
let VEConf.filePanelHotkey.refresh         = 'r'
let VEConf.filePanelHotkey.toggleTreePanel = 't'
let VEConf.filePanelHotkey.toggleModes     = 'i'
let VEConf.filePanelHotkey.newFile         = '+f'
let VEConf.filePanelHotkey.newDirectory    = '+d'
let VEConf.filePanelHotkey.switchPanel     = '<c-tab>'
let VEConf.filePanelHotkey.quitVE          = 'Q'
let VEConf.filePanelHotkey.toggleHidden    = 'H'
let VEConf.filePanelHotkey.search          = 'g/'
let VEConf.filePanelHotkey.markPlace       = 'm'
let VEConf.filePanelHotkey.gotoPlace       = "'"
let VEConf.filePanelHotkey.viewMarks       = 'J'
"Browsing
let VEConf.filePanelHotkey.toUpperDir      = '<bs>'
let VEConf.filePanelHotkey.gotoForward     = '<c-i>'
let VEConf.filePanelHotkey.gotoBackward    = '<c-o>'
let VEConf.filePanelHotkey.favorite        = 'f'
let VEConf.filePanelHotkey.addToFavorite   = 'F'
let VEConf.filePanelHotkey.browseHistory   = 'b'
let VEConf.filePanelHotkey.gotoPath        = '<c-g>'
"single file actions
let VEConf.filePanelHotkey.rename          = 'R'
let VEConf.filePanelHotkey.yankSingle      = 'yy'
let VEConf.filePanelHotkey.cutSingle       = 'xx'
let VEConf.filePanelHotkey.showYankList    = 'yl'
let VEConf.filePanelHotkey.deleteSingle    = 'dd'
let VEConf.filePanelHotkey.openPreview     = 'u'
let VEConf.filePanelHotkey.closePreview    = 'U'
"mark
let VEConf.filePanelHotkey.toggleSelectUp  = '<s-space>'
let VEConf.filePanelHotkey.toggleSelectDown= '<space>'
let VEConf.filePanelHotkey.markViaRegexp   = 'Mr'
let VEConf.filePanelHotkey.markVimFiles    = 'Mv'
let VEConf.filePanelHotkey.markDirectory   = 'Md'
let VEConf.filePanelHotkey.markExecutable  = 'Me'
let VEConf.filePanelHotkey.clearSelect     = 'Mc'
"multiple file actions
let VEConf.filePanelHotkey.deleteSelected  = 'sd'
let VEConf.filePanelHotkey.yankSelected    = 'sy'
let VEConf.filePanelHotkey.cutSelected     = 'sx'
let VEConf.filePanelHotkey.tabViewMulti    = 'se'
let VEConf.filePanelHotkey.paste           = 'p'
let VEConf.filePanelHotkey.diff2files      = '='
"visual mode hotkeys.
let VEConf.filePanelHotkey.visualSelect    = '<space>'
let VEConf.filePanelHotkey.visualDelete    = 'd'
let VEConf.filePanelHotkey.visualYank      = 'y'
let VEConf.filePanelHotkey.visualCut       = 'x'
"User defined hotkeys, see below.
let VEConf.filePanelHotkey.tabView         = 'e'
let VEConf.filePanelHotkey.openRenamer     = ';r'
let VEConf.filePanelHotkey.startShell      = ';c'
let VEConf.filePanelHotkey.startExplorer   = ';e'

if exists("g:VEConf_fileHotkey")
    if type(g:VEConf_fileHotkey) != type({})
        echohl WarningMsg | echo "g:VEConf_fileHotkey is not dictionary type!" | echohl None
        finish
    endif
    for i in keys(g:VEConf_fileHotkey)
        let VEConf.filePanelHotkey[i] = g:VEConf_fileHotkey[i]
    endfor
endif

"#######################################################################
"User defined file actions.
if !exists("g:VEConf_normalActions")
    let VEConf_normalActions = {}
endif
if !exists("g:VEConf_normalHotKeys")
    let VEConf_normalHotKeys = {}
endif
if !exists("g:VEConf_singleFileActions")
    let VEConf_singleFileActions = {}
endif
if !exists("g:VEConf_singleFileHotKeys")
    let VEConf_singleFileHotKeys = {}
endif

if !exists("g:VEConf_multiFileActions")
    let VEConf_multiFileActions = {}
endif
if !exists("g:VEConf_multiFileHotKeys")
    let VEConf_multiFileHotKeys = {}
endif

"Template
"   let VEConf_singleFileHotKeys['actionName'] = '<hot_key>'
"   function! VEConf_singleFileActions['actionName'](path)
"       "do some jobs here.
"   endfunction
"
"the 'path' is the file name under cursor in the file panel, you
"can use this path to do some actions.
"Pay attention to the hotKeys you have defined, dont conflict
"whth the default hotKey bindings.
"Normal Actions just run in current path, no path needed to
"pass.

"There are some examples:
"Open current file using vim in a new tab.
let VEConf_singleFileHotKeys['openInNewTab'] = VEConf.filePanelHotkey.tabView
function! VEConf_singleFileActions['openInNewTab'](path)
    if !isdirectory(a:path)
        exec "tabe " . g:VEPlatform.escape(a:path)
    else
        exec "VE " . g:VEPlatform.escape(a:path)
    endif
endfunction

"Renamer is a very good plugin.
let VEConf_normalHotKeys['openRenamer'] = VEConf.filePanelHotkey.openRenamer
function! VEConf_normalActions['openRenamer']()
    Renamer
endfunction

"start shell in current directory.
let VEConf_normalHotKeys['startShell'] = VEConf.filePanelHotkey.startShell
function! VEConf_normalActions['startShell']()
    call g:VEPlatform.startShell()
endfunction

"start file explorer in current directory
"(nautilus,konquer,Explorer.exe and so on).
let VEConf_normalHotKeys['startExplorer'] = VEConf.filePanelHotkey.startExplorer
function! VEConf_normalActions['startExplorer']()
    call g:VEPlatform.startExplorer()
endfunction

"Delete multiple files.
"Multiple file name are contained in the fileList.
let VEConf_multiFileHotKeys['openMultiFilesWithVim'] = VEConf.filePanelHotkey.tabViewMulti
function! VEConf_multiFileActions['openMultiFilesWithVim'](fileList)
    if empty(a:fileList)
        return
    endif
    for i in a:fileList
        exec "tabe " . g:VEPlatform.escape(i)
    endfor
endfunction

"#######################################################################
"Syntax and highlight configuration.
function! VEConf.treePanelSyntax()
    syn clear
    syn match Question "^.*Press ? for help.*$" "Host name
    syn match WarningMsg "\[[A-Z]:[\\/]\]" "root node name
    syn match Identifier "^\s*\zs[+-]" "+-
    syn match SpecialKey "^.*\[current\]$" "current folder
endfunction

function! VEConf.filePanelSyntax()
    syntax clear
    syn match Type "\[ .* \]" "group
    syn match Comment '\t.\{10}' "file size
    syn match Comment '\d\{4}-\d\{2}-\d\{2}\ \d\{2}:\d\{2}:\d\{2}' "time
    syn match Special '^Path: .*$' "path
    syn match WarningMsg '^\~*$' "line
    syn match Function '^.*[\\/]' "directory
    syn match Search '^\*.*$'  "selectedFiles
    syn match LineNr '[rwx-]\{9}' "perm
endfunction

"#######################################################################

" classes relationship
"
" VEFrameWork
"    VETreePanel
"       VETree
"           VENode
"    VEFilePanel
" VEPlatform

" class VEPlatform {{{1
"=============================
let VEPlatform = {}

"it's a static class, no constructor

"has win
function! VEPlatform.haswin32()
    if (has("win32") || has("win95") || has("win64") || has("win16"))
        return 1
    else
        return 0
    endif
endfunction

"return a path always end with slash.
function! VEPlatform.getcwd()
    let path = getcwd()
    if g:VEPlatform.haswin32() && !&ssl
        if path[-1:] != "\\"
            let path = path . "\\"
        endif
    else
        if path[-1:] != "/"
            let path = path . "/"
        endif
    endif
    return path
endfunction

"get home path, end with a slash
function! VEPlatform.getHome()
    if g:VEPlatform.haswin32() && !&ssl
        if $HOME[-1:] != "\\"
            return $HOME . "\\"
        else
            return $HOME
        endif
    else
        if $HOME[-1:] != "/"
            return $HOME . "/"
        else
            return $HOME
        endif
    endif
endfunction

function! VEPlatform.escape(path)
    if g:VEPlatform.haswin32()
        return escape(a:path,'%#')
    else
        return escape(a:path,' %#')
    endif
endfunction

"start a program and then return to vim, no wait.
function! VEPlatform.start(path)
    let convPath = self.escape(a:path)
    "escape() function will do iconv to the string, so call it
    "before iconv().
    if g:VEPlatform.haswin32()
        let convPath = substitute(convPath,'/',"\\",'g')
        let convPath = " start \"\" \"" . convPath . "\""
        let ret = self.system(convPath)
    else
        if g:VEConf_usingKDE
            let convPath = "kfmclient exec " . convPath
            let ret = self.system(convPath)
        elseif g:VEConf_usingGnome
            let convPath = "gnome-open " . convPath
            let ret = self.system(convPath)
        else " default using gnome-open.
            let convPath = "gnome-open " . convPath
            let ret = self.system(convPath)
        endif
    endif
    if !ret
        echohl ErrorMsg | echomsg "Failed to start " . a:path | echohl None
        return 0
    endif
    return 1
endfunction

function! VEPlatform.system(cmd)
    "can not escape here! example: 'rm -r blabla\ bbb'
    "let convCmd = escape(a:cmd,' %#')
    let convCmd = a:cmd
    if g:VEConf.systemEncoding != ''
        let convCmd = iconv(convCmd,&encoding,g:VEConf.systemEncoding)
    endif
    call system(convCmd)
    return !(v:shell_error)
endfunction

" Return successful copyed file list.
function! VEPlatform.copyMultiFile(fileList,topath)
    let boverWrite = g:VEConf.overWriteExisting
    let retList = []
    for i in a:fileList
        "boverWrite 0 ask, 1 allyes, 2 allno
        if boverWrite == 0
            if i[-1:] == "\\" || i[-1:] == "/"
                let i = i[:-2]
            endif
            let tofile = a:topath . matchstr(i,'[\\/]\zs[^\\/]\+$')
            if findfile(tofile) != ''
                "echohl WarningMsg
                "let result = tolower(input("File [ " . tofile . " ] exists! Over write ? (Y)es/(N)o/(A)llyes/A(L)lno/(C)ancel ","Y"))
                let result = confirm("File [ " . matchstr(i,'[\\/]\zs[^\\/]\+$') .
                            \" ] exists! Over write ? ","&Yes\n&No\nYes to &All\nNo &To All\n&Cancel ",1)
                "echohl None
                if result == 1
                    if !self.copyfile(i,a:topath)
                        echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
                    else
                        let retList += [i]
                    endif
                elseif result == 2
                    continue
                elseif result == 3
                    let boverWrite = 1
                    if !self.copyfile(i,a:topath)
                        echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
                    else
                        let retList += [i]
                    endif
                elseif result == 4
                    let boverWrite = 2
                else
                    break
                endif
            else
                if !self.copyfile(i,a:topath)
                    echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
                else
                    let retList += [i]
                endif
            endif
        elseif boverWrite == 1
            if !self.copyfile(i,a:topath)
                echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
            else
                let retList += [i]
            endif
        elseif boverWrite == 2
            if i[-1:] == "\\" || i[-1:] == "/"
                let i = i[:-2]
            endif
            let tofile = a:topath . matchstr(i,'[\\/]\zs[^\\/]\+$')
            if findfile(tofile) != ''
                continue
            endif
            if !self.copyfile(i,a:topath)
                echohl ErrorMsg | echomsg "Copy file error: " . i | echohl None
            else
                let retList += [i]
            endif
        endif
    endfor
    echohl Special | echomsg " " . len(retList) . " file(s) pasted!" | echohl None
    return retList
endfunction

function! VEPlatform.copyfile(filename,topath)
    let filename = self.escape(a:filename)
    let topath = self.escape(a:topath)
    if g:VEPlatform.haswin32()
        let filename = substitute(a:filename,'/',"\\",'g')
        let topath = substitute(a:topath,'/',"\\",'g')
        if isdirectory(filename)
            if filename[-1:] == "\\"
                let filename = filename[:-2]
            endif
            let topath = "\"" . topath . matchstr(filename,'[^\\]*$') . "\""
            let filename = "\"" . filename . "\""
            let cmd = "xcopy ".filename . " " . topath . " /E /I /H /R /Y"
        else
            let topath = "\"" . topath . "\""
            let filename = "\"" . filename . "\""
            let cmd = "xcopy ". filename . " " . topath . " /I /H /R /Y"
        endif
        return self.system(cmd)
    else
        let cmd = "cp -r " . filename . " " . topath
        return self.system(cmd)
    endif
endfunction

function! VEPlatform.mkdir(path)
    if g:VEConf.systemEncoding != ''
        let convPath = iconv(a:path,&encoding,g:VEConf.systemEncoding)
    else
        let convPath = a:path
    endif
    return mkdir(convPath)
endfunction

function! VEPlatform.mkfile(filename)
    if findfile(a:filename) != '' || isdirectory(a:filename)
        return 0
    endif
    if writefile([],a:filename) == 0 "here it is not need to convert filename
        return 1
    else
        return 0
    endif
endfunction

function! VEPlatform.executable(filename)
    if isdirectory(a:filename)
        return 0
    endif
    if getfperm(a:filename)[2] == 'x'
        return 1
    else
        return 0
    endif
endfunction

function! VEPlatform.search(filename,path)
    if a:filename == '.' || a:filename == '..'
        return []
    else
        return split(globpath(a:path,"**/" . a:filename),"\n")
    endif
endfunction

function! VEPlatform.globpath(path)
    if g:VEConf.showHiddenFiles
        let tmp = globpath(a:path,"*") . "\n" . globpath(a:path,".[^.]*") "need to cut . and ..
        " can not show files start with .. such as ..foo , :(
        " I do not know how to write the shell regexp.
        if tmp == "\n"
            return ''
        else
            return tmp
        endif
    else
        return globpath(a:path,"*")
    endif
endfunction

"globpath used in file panel, including filter.
function! VEPlatform.globpath_file(path)
    if g:VEConf.filePanelFilter != ''
        return globpath(a:path,g:VEConf.filePanelFilter)
    endif
    if g:VEConf.showHiddenFiles
        let tmp = globpath(a:path,"*") . "\n" . globpath(a:path,".[^.]*") "need to cut . and ..
        " can not show files start with .. such as ..foo , :(
        " I do not know how to write the shell regexp.
        if tmp == "\n"
            return ''
        else
            return tmp
        endif
    else
        return globpath(a:path,"*")
    endif
endfunction

function! VEPlatform.cdToPath(path)
    try
        "In win32, VE can create folder starts with space. So ...
        exec "lcd " . escape(a:path,' %#')
    catch
        echohl ErrorMsg | echomsg "Can not cd to path: " . a:path | echohl None
    endtry
endfunction

function! VEPlatform.startShell()
    if g:VEPlatform.haswin32()
        !start cmd.exe
    else
        shell
    endif
endfunction

function! VEPlatform.startExplorer()
    let pwd = self.escape(g:VEPlatform.getcwd())
    if g:VEPlatform.haswin32()
        let pwd = substitute(pwd,'/',"\\",'g')
    endif
    if !self.system(g:VEConf.externalExplorer . " " . pwd)
        echohl ErrorMsg | echomsg "Failed to start external explorer: " . g:VEConf.externalExplorer | echohl None
    endif
endfunction

function! VEPlatform.getRoot(rootDict)
    if g:VEPlatform.haswin32()
        "Create new root list.
        let newRootList = []
        for i in g:VEConf.win32Disks
            if &ssl
                let i = i . "/"
            else
                let i = i . "\\"
            endif
            if g:VEPlatform.globpath(i) != ''
                call add(newRootList,i)
            endif
        endfor
        "Remove nolonger exist root nodes.
        for i in keys(a:rootDict)
            if index(newRootList,i) == -1
                call remove(a:rootDict,i)
            endif
        endfor
        "Create new root nodes.
        for i in newRootList
            if !has_key(a:rootDict,i)
                let a:rootDict[i] = deepcopy(s:VENode)
                call a:rootDict[i].init(i)
                let a:rootDict[i].hasOwnChilds = 1
            endif
        endfor
    else "Assert the other platform acts like UNIX
        let newRootList = ["/"]  " ~/
        for i in newRootList
            if !has_key(a:rootDict,i)
                let a:rootDict[i] = deepcopy(s:VENode)
                call a:rootDict[i].init(i)
                let a:rootDict[i].hasOwnChilds = 1
            endif
        endfor
    endif
endfunction

function! VEPlatform.pathToName(path)
    let time = strftime("%Y-%m-%d %H:%M:%S",getftime(a:path))
    let size = getfsize(a:path)
    let perm = getfperm(a:path)
    if g:VEPlatform.haswin32() && !&ssl
        if a:path[-1:] != "\\"
            let name = substitute(a:path,'^.*\\','','g')
        else
            let name = substitute(a:path,'^.*\\\ze.\+\\$','','g')
        endif
    else
        if a:path[-1:] != "/"
            let name = substitute(a:path,'^.*\/','','g')
        else
            let name = substitute(a:path,'^.*\/\ze.\+\/$','','g')
        endif
    endif
    if g:VEConf.showFileSizeInMKB
        if size > (1024 * 1024)
            let size = (size / 1024 / 1024) . ' M'
        elseif size > 1024
            let size = (size / 1024) . ' K'
        elseif size > 0
            let size = size . ' B'
        endif
    endif
    let tail = printf("%10.10s ".perm . ' ' .time,size==0?'':size)
    return name . "\t" . tail
endfunction

function! VEPlatform.getUpperDir(path)
    if g:VEPlatform.haswin32() && !&ssl
        return substitute(a:path,'\\\zs[^\\]\+\\$','','g')
    else
        return substitute(a:path,'\/\zs[^/]\+\/$','','g')
    endif
endfunction

"default choice and return value:    1:YES 0:NO
function! VEPlatform.confirm(text,defaultChoice)
    if a:defaultChoice
        let ret = confirm(a:text,"&Yes\n&No",1)
    else
        let ret = confirm(a:text,"&Yes\n&No",2)
    endif
    if ret == 1
        return 1
    else
        return 0
    endif
    "if a:defaultChoice
    "    echohl WarningMsg
    "    let result = tolower(input(a:text . "  ","Y"))
    "    echohl None
    "else
    "    echohl WarningMsg
    "    let result = tolower(input(a:text . "  "),"N")
    "    echohl None
    "endif
    "if result == "y" || result == "ye" || result == "yes"
    "    return 1
    "else
    "    return 0
    "endif
endfunction

"delete a single file or directory
"return 0:failed  1:success
function! VEPlatform.deleteSingle(path)
    if !isdirectory(a:path)
        if g:VEConf.fileDeleteConfirm && !self.confirm("Delete file: ".a:path,1)
            echo " "
            "clear the command line
            return 0
        endif
        if self.delete(a:path)
            echohl Special | echomsg "File: [" . a:path . "] deleted!" | echohl None
            return 1
        else
            echohl ErrorMsg | echomsg "Can not delete the file! [" . a:path . "]" | echohl None
            return 0
        endif
    else
        if g:VEConf.fileDeleteConfirm && !self.confirm("Delete the DIR Recursively? : ".a:path,1)
            echo " "
            return 0
        endif
        echo " "
        return self.delete(a:path)
    endif
endfunction

"delete multiple files/directory.
"return 0:failed  1:success
function! VEPlatform.deleteMultiple(fileList)
    if g:VEConf.fileDeleteConfirm && !self.confirm("Are you sure to delete selected file(s) ?",1)
        echo " "
        return 0
    endif
    for i in a:fileList
        if !self.delete(i)
            echohl ErrorMsg | echomsg "Failed to delete: " . i | echohl None
        endif
    endfor
    return 1
endfunction

function! VEPlatform.delete(name)
    if isdirectory(a:name)
        "I have no idea how to judge if it is succeed :(
        if g:VEPlatform.haswin32()
            return g:VEPlatform.system(" rmdir /S /Q \"" . self.escape(a:name) . "\"")
        else
            return g:VEPlatform.system("rm -r " . self.escape(a:name))
        endif
    else
        if delete(a:name) == 0
            return 1
        else
            return 0
        endif
    endif
endfunction

function! VEPlatform.select(list,title)
    let selectList = deepcopy(a:list)
    if len(selectList) == 0
        return
    endif
    call insert(selectList,a:title,0)
    for i in range(1,len(selectList)-1)
        let selectList[i] = i . "  " . selectList[i]
    endfor
    let result = inputlist(selectList)
    if result > len(a:list) || result <= 0
        return -1
    else
        return result-1
    endif
endfunction

" This is not a member of VEPlatform, because sort()
" can not use dict function.
function! VEPlatform_sortCompare(t1,t2)
    if g:VEConf.sortCaseSensitive
        return a:t1 ==# a:t2 ? 0 : a:t1 ># a:t2 ? 1 : -1
    else
        return a:t1 ==? a:t2 ? 0 : a:t1 >? a:t2 ? 1 : -1
    endif
endfunction


" class VENode {{{1
"=============================
let s:VENode = {}
let s:VENode.name = ''
let s:VENode.path = ''
let s:VENode.isopen = 0
let s:VENode.hasOwnChilds = 0
let s:VENode.childs = {}

"Object Constructor
function! s:VENode.init(path)
    let self.path = a:path
    if g:VEPlatform.haswin32() && !&ssl
        let self.name = matchstr(a:path,'[^\\]*\\$','','g')
    else
        let self.name = matchstr(a:path,'[^/]*\/$','','g')
    endif
endfunction

"Refresh tree node
function! s:VENode.updateNode()
    "Once a node is updated, it means that the node has been opened.
    let self.isopen = 1
    "Create new dir list
    let newDirList = []
    for i in split(g:VEPlatform.globpath(self.path),"\n")
        if isdirectory(i) == 1
            if g:VEPlatform.haswin32() && !&ssl
                let i = matchstr(i,'[^\\]*$','','g') . "\\"
            else
                let i = matchstr(i,'[^/]*$','','g') . "/"
            endif
            call add(newDirList,i)
        endif
    endfor
    "Remove nolonger exist dirs.
    for i in keys(self.childs)
        if index(newDirList,i) == -1
            call remove(self.childs,i)
        endif
    endfor
    "Create new nodes
    for i in newDirList
        if !has_key(self.childs,i)
            let self.childs[i] = deepcopy(s:VENode)
            call self.childs[i].init(self.path . i)
        endif
    endfor
    "find out which child has their own childs
    if !empty(self.childs)
        let self.hasOwnChilds = 1
    else
        let self.hasOwnChilds = 0
        return
    endif
    if g:VEConf.showFolderStatus == 0
        for i in keys(self.childs)
            let self.childs[i].hasOwnChilds = 1
        endfor
    else
        for i in keys(self.childs)
            let _hasOwnChilds = 0
            for j in split(g:VEPlatform.globpath(self.childs[i].path),"\n")
                if isdirectory(j) == 1
                    let _hasOwnChilds = 1
                    break
                endif
            endfor
            if _hasOwnChilds == 1
                let self.childs[i].hasOwnChilds = 1
            endif
        endfor
    endif
    "update opened child nodes
    for i in keys(self.childs)
        if self.childs[i].isopen == 1
            call self.childs[i].updateNode()
        endif
    endfor
endfunction

"Toggle open/close status of one node
"the path should end with '\' such as c:\aaa\bbb\
"example "c:\\aaa\\bbb\\" "aaa\\bbb\\" "bbb\\"
function! s:VENode.toggle(path)
    if g:VEPlatform.haswin32() && !&ssl
        let childPath = substitute(a:path,'^.\{-}\\','','g')
    else
        let childPath = substitute(a:path,'^.\{-}\/','','g')
    endif
    if childPath == ''
        let self.isopen = !self.isopen
        if self.isopen == 1
            call self.updateNode()
        endif
    else
        if g:VEPlatform.haswin32() && !&ssl
            let nodeName = matchstr(childPath,'^.\{-}\\')
        else
            let nodeName = matchstr(childPath,'^.\{-}\/')
        endif
        if !has_key(self.childs,nodeName)
            echoerr "path error"
        endif
        let self.isopen = 1
        call self.childs[nodeName].toggle(childPath)
    endif
endfunction

"Open the giving path
"the path should end with '\' such as c:\aaa\bbb\
"example "c:\\aaa\\bbb\\" "aaa\\bbb\\" "bbb\\"
function! s:VENode.openPath(path)
    if g:VEPlatform.haswin32() && !&ssl
        let childPath = substitute(a:path,'^.\{-}\\','','g')
    else
        let childPath = substitute(a:path,'^.\{-}\/','','g')
    endif
    if childPath == ''
        if empty(self.childs)
            call self.updateNode()
        endif
        return
    else
        if g:VEPlatform.haswin32() && !&ssl
            let nodeName = matchstr(childPath,'^.\{-}\\')
        else
            let nodeName = matchstr(childPath,'^.\{-}\/')
        endif
        if !has_key(self.childs,nodeName)
            call self.updateNode()
        endif
        if !has_key(self.childs,nodeName) "refreshed and still can not find the path.
            echoerr "Path error!"
            return
        else
            let self.isopen = 1
            call self.childs[nodeName].openPath(childPath)
        endif
    endif
endfunction


"Draw the tree, depend on the status of every tree node.
function! s:VENode.draw(tree,depth)
    if self.hasOwnChilds == 0
        let name = repeat(' ',a:depth*2).'  '.self.name
        call add(a:tree,[name,self.path])
        return
    endif
    if self.isopen
        let name = repeat(' ',a:depth*2).'- '.self.name
        if a:depth == 0 "let the root node looks different
            let name = '- [' . self.name . ']'
        endif
        call add(a:tree,[name,self.path])
        let keys = sort(keys(self.childs),"VEPlatform_sortCompare")
        if !g:VEConf.treeSortDirection
            call reverse(keys)
        endif
        for i in keys
            call self.childs[i].draw(a:tree,a:depth+1)
        endfor
    else
        let name = repeat(' ',a:depth*2).'+ '.self.name
        if a:depth == 0 "let the root node looks different
            let name = '+ [' . self.name . ']'
        endif
        call add(a:tree,[name,self.path])
    endif
endfunction

" class VETree {{{1
"=============================
let s:VETree = {}
let s:VETree.content = []
let s:VETree.rootNodes = {}

"Object Constructor
function! s:VETree.init()
    call g:VEPlatform.getRoot(self.rootNodes)
    "for i in keys(self.rootNodes)
    "    call self.rootNodes[i].updateNode()
    "endfor
endfunction

function! s:VETree.togglePath(path)
    if g:VEPlatform.haswin32() && !&ssl
        let rootNodeName = matchstr(a:path,'^.\{-}\\')
    else
        let rootNodeName = matchstr(a:path,'^.\{-}\/')
    endif
    call self.rootNodes[rootNodeName].toggle(a:path)
endfunction

function! s:VETree.openPath(path)
    if g:VEPlatform.haswin32() && !&ssl
        let rootNodeName = matchstr(a:path,'^.\{-}\\')
    else
        let rootNodeName = matchstr(a:path,'^.\{-}\/')
    endif
    call self.rootNodes[rootNodeName].openPath(a:path)
endfunction

" fill self.content
function! s:VETree.draw()
    let keys = sort(keys(self.rootNodes),"VEPlatform_sortCompare")
    if g:VEConf.treeSortDirection == 0
        call reverse(keys)
    endif
    for i in keys
        call self.rootNodes[i].draw(self.content,0)
    endfor
endfunction

function! s:VETree.update(path)
    call g:VEPlatform.getRoot(self.rootNodes)
    "toggle twice to update current directory
    call self.togglePath(a:path)
    call self.togglePath(a:path)
    " costs too much time.
    "for i in keys(self.rootNodes)
    "    call self.rootNodes[i].updateNode()
    "endfor
endfunction

" class VETreePanel {{{1
"=============================
let s:VETreePanel = {}
let s:VETreePanel.tree = {}
let s:VETreePanel.name = ''
let s:VETreePanel.path = ''
let s:VETreePanel.width = 0
let s:VETreePanel.splitMode = ''
let s:VETreePanel.splitLocation = ''

"Object Constructor
function! s:VETreePanel.init(name,path)
    let self.name = "VETreePanel" . a:name
    let self.path = a:path
    let self.width = g:VEConf.treePanelWidth
    let self.splitMode = g:VEConf.treePanelSplitMode
    let self.splitLocation = g:VEConf.treePanelSplitLocation
    let self.tree = deepcopy(s:VETree)
    call self.tree.init()
    call self.tree.openPath(a:path)
endfunction

function! s:VETreePanel.setFocus()
    let VETreeWinNr = bufwinnr(self.name)
    if VETreeWinNr != -1
        exec VETreeWinNr . " wincmd w"
        return 1
    else
        let bufNr = bufnr(self.name)
        if bufNr != -1
            exec "bwipeout " . bufNr
        endif
        return 0
    endif
endfunction

"Sync the tree with filesystem and refresh the tree panel
function! s:VETreePanel.refresh()
    if !self.setFocus()
        return
    endif
    call self.tree.update(self.path)
    call self.drawTree()
endfunction

"Draw the dir tree but do not sync the tree with filesystem
function! s:VETreePanel.drawTree()
    if !self.setFocus()
        return
    endif
    if !empty(self.tree.content)
        call remove(self.tree.content,0,-1)
    endif
    call add(self.tree.content,[hostname() . "  (Press ? for help)",""])
    call self.tree.draw()
    let tree = []
    let lineNr = line(".")
    for i in self.tree.content
        if i[1] == self.path
            let i[0] = i[0] . "  [current]"
            let lineNr = index(self.tree.content,i) + 1
        endif
        call add(tree,i[0])
    endfor
    setlocal noreadonly
    setlocal modifiable
    "Let the cursor go back to right line and right position in
    "the screen.
    normal! H
    let Hline = line(".")
    silent normal! ggdG
    call append(0,tree)
    silent normal! Gddgg
    exec "normal! " . Hline . "G"
    normal! zt
    exec "normal! " . lineNr . "G"
    setlocal readonly
    setlocal nomodifiable
endfunction

"Show tree panel
function! s:VETreePanel.show()
    if self.setFocus()
        return
    endif
    let cmd = self.splitLocation . " " . self.splitMode . ' ' . self.width . ' new ' . self.name
    silent! execute cmd
    let VETreeWinNr = bufwinnr(self.name)
    if VETreeWinNr != -1
        exec VETreeWinNr . " wincmd w"
        setlocal winfixwidth
        setlocal noswapfile
        setlocal buftype=nowrite
        setlocal bufhidden=delete
        setlocal nowrap
        setlocal foldcolumn=0
        setlocal nobuflisted
        setlocal nospell
        setlocal nonumber
        setlocal cursorline
        setlocal readonly
        setlocal nomodifiable
        "call self.refresh()
        call self.drawTree()
        call self.createActions()
        call self.createSyntax()
    else
        echoerr "create tree window failed!"
    endif
endfunction

"Hide tree panel
function! s:VETreePanel.hide()
    if !self.setFocus()
        return
    else
        "make sure there are no more than 1 buffer has the same name
        let bufNr = bufnr('%')
        "exec "wincmd c"
        quit
        exec "bwipeout ".bufNr
    endif
endfunction

function! s:VETreePanel.getPathUnderCursor(num)
    return self.tree.content[a:num][1]
endfunction

function! s:VETreePanel.nodeClicked(num)
    if self.tree.content[a:num][1] == ""
        return
    endif
    let path = self.tree.content[a:num][1]
    if self.path != path
        "let self.path = path
        call VE_GotoPath(path)
        "Do not toggle if it is the first time switch to another tree node.
        call self.setFocus()
        return
    endif
    call self.tree.togglePath(path)
    call self.drawTree()
endfunction

function! s:VETreePanel.pathChanged(path)
    if self.path == a:path
        return
    endif
    call g:VEPlatform.cdToPath(a:path)
    let self.path = g:VEPlatform.getcwd()
    call self.tree.openPath(self.path)
    call self.drawTree()
endfunction

function! s:VETreePanel.createActions()
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.help .           " :tab h VimExplorer<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.toggleNode .     " :call VE_OnTreeNodeClick()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.toggleNodeMouse. " :call VE_OnTreeNodeClick()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.refresh .        " :call VE_TreeRefresh()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.toggleFilePanel ." :call VE_ToggleFilePanel()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.toUpperDir .     " :call VE_ToUpperDir()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.switchPanel .    " <c-w><c-w>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.favorite .       " :call VE_GotoFavorite()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.addToFavorite .  " :call VE_AddToFavorite('treePanel')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.browseHistory .  " :call VE_BrowseHistory()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.gotoPath .       " :call VE_OpenPath()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.treePanelHotkey.quitVE .         " :call VEDestroy()<cr>"
    " autocmd
    au! * <buffer>
    au BufEnter <buffer>  call VE_SyncDir()
    " Status line
    setlocal statusline=%{getcwd()}
endfunction

function! s:VETreePanel.createSyntax()
    if !self.setFocus()
        return
    endif
    call g:VEConf.treePanelSyntax()
endfunction


" class VEFilePanel {{{1
"=============================
let s:VEFilePanel = {}
let s:VEFilePanel.fileList = []
let s:VEFilePanel.displayList = []
" displayList [
"    [ "display name", "real path" ],
"    ...
"    ]
let s:VEFilePanel.selectedFiles = []
let s:VEFilePanel.name = ''
let s:VEFilePanel.path = ''
let s:VEFilePanel.width = 0
let s:VEFilePanel.splitMode = ""
let s:VEFilePanel.splitLocation = ""

function! s:VEFilePanel.init(name,path)
    let self.name = "VEFilePanel".a:name
    let self.path = a:path
    let self.splitMode = g:VEConf.filePanelSplitMode
    let self.splitLocation = g:VEConf.filePanelSplitLocation
    let self.width = g:VEConf.filePanelWidth
endfunction

function! s:VEFilePanel.show()
    if self.setFocus()
        return
    endif
    let cmd = self.splitLocation . " " . self.splitMode . ' ' . self.width . ' new ' . self.name
    silent! exec cmd
    if !self.setFocus()
        echoerr "create file window failed!"
    endif
    setlocal winfixwidth
    setlocal noswapfile
    setlocal buftype=nowrite
    setlocal bufhidden=delete
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal nobuflisted
    setlocal nospell
    setlocal nonumber
    setlocal cursorline
    setlocal readonly
    setlocal nomodifiable
    setlocal tabstop=40
    "This is used to display file list more orderliness.
    call self.refresh()
    call self.createActions()
    call self.createSyntax()
endfunction

function! s:VEFilePanel.only()
    if !self.setFocus()
        return
    endif
    only
endfunction

function! s:VEFilePanel.hide()
    if !self.setFocus()
        return
    else
        let bufNr = bufnr('%')
        exec "wincmd c"
        exec "bwipeout ".bufNr
    endif
endfunction

function! s:VEFilePanel.refresh()
    call self.getFileListFromCwd()
    call self.updateDisplayList()
    call self.drawList()
endfunction

"Draw the displayList on the screen.
function! s:VEFilePanel.drawList()
    if !self.setFocus()
        return
    endif
    "calculate window width
    let VEFileWinNr = bufwinnr(self.name)
    let winWidth = winwidth(VEFileWinNr)
    exec "setlocal tabstop=" . ((winWidth-41)<20?20:(winWidth-41))
    setlocal noreadonly
    setlocal modifiable
    let curLine = line(".")
    normal! H
    let Hline = line(".")
    silent normal! ggdG
    let displayContent = []
    for i in self.displayList "here i is reference,not copy
        if index(self.selectedFiles,i[1]) != -1
            let tmpi = '*' . substitute(i[0],'^.','','g')
        else
            let tmpi = i[0]
        endif
        call add(displayContent,tmpi)
    endfor
    call append(0,displayContent)
    normal! Gddgg
    exec "normal! " . Hline . "G"
    normal! zt
    exec "normal! " . curLine . "G"
    setlocal readonly
    setlocal nomodifiable
endfunction

"Update the displayList.
function! s:VEFilePanel.updateDisplayList()
    if g:VEConf.filePanelSortType == 1
        call self.sortByName()
    elseif g:VEConf.filePanelSortType == 2
        call self.sortByTime()
    else
        call self.sortByType()
    endif
endfunction

function! s:VEFilePanel.toggleModes()
    if g:VEConf.filePanelSortType < 2
        let g:VEConf.filePanelSortType = g:VEConf.filePanelSortType + 1
    else
        let g:VEConf.filePanelSortType = 0
    endif
    call self.updateDisplayList()
    call self.drawList()
endfunction

function! s:VEFilePanel.getFileListFromCwd()
    let self.fileList = split(g:VEPlatform.globpath_file(self.path),"\n")
endfunction

" 1
function! s:VEFilePanel.sortByName()
    let fileGroup = {}
    " example
    " {
    "  "name" : "path"
    " }
    for i in self.fileList
        if g:VEPlatform.haswin32() && !&ssl
            let name =  matchstr(i,'[^\\]*$','','g')
        else
            let name =  matchstr(i,'[^/]*$','','g')
        endif
        if isdirectory(i)
            if g:VEPlatform.haswin32() && !&ssl
                if i[-1:] != "\\"
                    let i = i . "\\"
                endif
            else
                if i[-1:] != "/"
                    let i = i . "/"
                endif
            endif
            " add # before directory to sort separately.
            let name = '#' . name
        endif
        let fileGroup[name] = i
    endfor
    let keys = sort(keys(fileGroup),"VEPlatform_sortCompare")
    if !g:VEConf.fileGroupSortDirection
        call reverse(keys)
    endif
    let self.displayList = []
    call add(self.displayList,["Path:  ".self.path,''])
    call add(self.displayList,[repeat("~",100),''])
    call add(self.displayList,['[ Sort by name ]',''])
    for i in keys
        call add(self.displayList,["  " . g:VEPlatform.pathToName(fileGroup[i]),fileGroup[i]])
    endfor
endfunction

" 2
function! s:VEFilePanel.sortByTime()
    let fileGroup = {}
    " example
    " {
    "  "name" : "path"
    " }
    for i in self.fileList
        let time = strftime("%Y-%m-%d %H:%M:%S",getftime(i))
        let time = time . i "let the key of dict unique
        if isdirectory(i)
            if g:VEPlatform.haswin32() && !&ssl
                if i[-1:] != "\\"
                    let i = i . "\\"
                endif
            else
                if i[-1:] != "/"
                    let i = i . "/"
                endif
            endif
        endif
        let fileGroup[time] = i
    endfor
    let keys = sort(keys(fileGroup),"VEPlatform_sortCompare")
    if !g:VEConf.fileGroupSortDirection
        call reverse(keys)
    endif
    let self.displayList = []
    call add(self.displayList,["Path:  ".self.path,''])
    call add(self.displayList,[repeat("~",100),''])
    call add(self.displayList,['[ Sort by time ]',''])
    for i in keys
        call add(self.displayList,["  " . g:VEPlatform.pathToName(fileGroup[i]),fileGroup[i]])
    endfor
endfunction

" 3 not implemented yet
"function! s:VEFilePanel.sortBySize()
"    let fileGroup = {}
"    " example
"    " {
"    "  "name" : "path"
"    " }
"    for i in self.fileList
"        let time = strftime("%Y-%m-%d %H:%M:%S",getftime(i))
"        let time = time . i "let the key of dict unique
"        if isdirectory(i)
"            " add # before directory to sort separately.
"            " need??
"            "let time = '#' . time
"            if i[-1:] != "\\"
"                let i = i . "\\"
"            endif
"        endif
"        let fileGroup[time] = i
"    endfor
"    let keys = sort(keys(fileGroup))
"    if !g:VEConf.fileGroupSortDirection
"        call reverse(keys)
"    endif
"    let self.displayList = []
"    call add(self.displayList,["Path:  ".self.path,''])
"    call add(self.displayList,[repeat("~",100),''])
"    call add(self.displayList,['[ Sort by time ]',''])
"    for i in keys
"        call add(self.displayList,["  " . g:VEPlatform.pathToName(fileGroup[i]),fileGroup[i]])
"    endfor
"endfunction

" 0
function! s:VEFilePanel.sortByType()
    let fileGroup = {}
    " example
    " {
    "  "directory" : [
    "                 "c:\\aaa\\",
    "                 "c:\\bbb\\"
    "                 ]
    "  "txt"       : [
    "                 "c:\\mm.txt",
    "                 "c:\\nn.txt"
    "                 ]
    " }
    for i in self.fileList
        " i ("c:\\ddd\\eee.fff")
        if isdirectory(i)
            "if the group dos not exist,create it first
            if !has_key(fileGroup,'#Directory') "assert file name does not contain '#'
                let fileGroup['#Directory'] = []
            endif
            if g:VEPlatform.haswin32() && !&ssl
                if i[-1:] != "\\"
                    let i = i . "\\"
                endif
            else
                if i[-1:] != "/"
                    let i = i . "/"
                endif
            endif
            call add(fileGroup['#Directory'],i)
            continue
        endif
        if g:VEPlatform.haswin32() && !&ssl
            let matchStr = '\\\..\+$'
        else
            let matchStr = '\/\..\+$'
        endif
        if matchstr(i,matchStr) != ''
            if !has_key(fileGroup,'#Hidden files')
                let fileGroup['#Hidden files'] = []
            endif
            call add(fileGroup['#Hidden files'],i)
            continue
        endif
        if g:VEPlatform.haswin32() && !&ssl
            let fileExtension = matchstr(substitute(i,'^.*\\','','g'),'\.[^.]\{-}$')
        else
            let fileExtension = matchstr(substitute(i,'^.*\/','','g'),'\.[^.]\{-}$')
        endif
        if fileExtension == ''  "files have no extensions
            if !has_key(fileGroup,'#Files')
                let fileGroup['#Files'] = []
            endif
            call add(fileGroup['#Files'],i)
            continue
        else "group the file by it's ext.name
            " # is always smaller than $
            " so it can keep dir in the top
            if !has_key(fileGroup,"$".fileExtension)
                let fileGroup["$".fileExtension] = []
            endif
            call add(fileGroup["$".fileExtension],i)
        endif
    endfor
    "update self.displayList
    let self.displayList = []
    call add(self.displayList,["Path:  ".self.path,''])
    call add(self.displayList,[repeat("~",100),''])
    let keys = sort(keys(fileGroup),"VEPlatform_sortCompare")
    if !g:VEConf.fileGroupSortDirection
        call reverse(keys)
    endif
    for i in keys
        call add(self.displayList,['[ '.i[1:].' ]',''])
        call sort(fileGroup[i],"VEPlatform_sortCompare")
        if !g:VEConf.fileGroupSortDirection
            call reverse(fileGroup[i])
        endif
        for j in fileGroup[i]
            call add(self.displayList,["  " . g:VEPlatform.pathToName(j),j])
        endfor
        call add(self.displayList,[" ",''])
    endfor
    if self.displayList[-1][0] == " "
        call remove(self.displayList,-1) "remove last empty line
    endif
endfunction

function! s:VEFilePanel.pathChanged(path)
    if self.path == a:path
        return
    endif
    call g:VEPlatform.cdToPath(a:path)
    let self.selectedFiles = [] "clear the selectedFile list
    let self.path = g:VEPlatform.getcwd()
    call self.refresh()
    normal! ggM
    "If path changed, set the cursor to the middle of the screen.
endfunction

function! s:VEFilePanel.setFocus()
    let VEFileWinNr = bufwinnr(self.name)
    if VEFileWinNr != -1
        exec VEFileWinNr . " wincmd w"
        return 1
    else
        "If the window of buffer was closed by hand and the
        "buffer still in buffer list, wipeout it.
        "In case of bufnr() returns empty when there are two
        "buffers have the same name.
        let bufNr = bufnr(self.name)
        if bufNr != -1
            exec "bwipeout " . bufNr
        endif
        return 0
    endif
endfunction

function! s:VEFilePanel.itemClicked(line)
    let path = self.displayList[a:line][1]
    if path == ''
        return
    endif
    if isdirectory(path)
        call VE_GotoPath(path)
        call self.setFocus()
        return
    else
        call g:VEPlatform.start(path)
    endif
endfunction

function! s:VEFilePanel.itemPreview(line)
    let path = self.displayList[a:line][1]
    if path == ''
        return
    endif
    exec g:VEConf.previewSplitLocation . " pedit " . g:VEPlatform.escape(path)
endfunction

function! s:VEFilePanel.singleFileAction(line,actionName)
    let path = self.displayList[a:line][1]
    if path == ''
        return
    endif
    call g:VEConf_singleFileActions[a:actionName](path)
endfunction

function! s:VEFilePanel.normalAction(actionName)
    call g:VEConf_normalActions[a:actionName]()
endfunction

function! s:VEFilePanel.multiAction(actionName)
    call g:VEConf_multiFileActions[a:actionName](self.selectedFiles)
endfunction

function! s:VEFilePanel.deleteSingle(line)
    let path = self.displayList[a:line][1]
    if path == ''
        return
    endif
    if g:VEPlatform.deleteSingle(path)
        if index(self.selectedFiles,path) != -1
            call remove(self.selectedFiles,index(self.selectedFiles,path))
        endif
        call self.refresh()
    endif
endfunction

function! s:VEFilePanel.deleteSelectedFiles()
    if empty(self.selectedFiles)
        return
    endif
    if g:VEPlatform.deleteMultiple(self.selectedFiles)
        call self.refresh()
    endif
endfunction

function! s:VEFilePanel.toggleSelect(direction)
    if a:direction == "up"
        exec "norm " . "\<up>"
    endif
    let line = line(".") - 1
    let path = self.displayList[line][1]
    if path != ''
        let idx = index(self.selectedFiles,path)
        if idx == -1
            call add(self.selectedFiles,path)
        else
            call remove(self.selectedFiles,idx)
        endif
        call self.drawList()
    endif
    if a:direction == "down"
        exec "norm " . "\<down>"
    endif
endfunction!

function! s:VEFilePanel.clearSelect()
    let self.selectedFiles = []
    call self.drawList()
endfunction

function! s:VEFilePanel.visualSelect(firstLine,lastLine)
    for line in range(a:firstLine,(a:lastLine>=len(self.displayList)?(len(self.displayList)-1):a:lastLine))
        let path = self.displayList[line][1]
        if path == ''
            continue
        endif
        let idx = index(self.selectedFiles,path)
        if idx == -1
            call add(self.selectedFiles,path)
        else
            call remove(self.selectedFiles,idx)
        endif
    endfor
    call self.drawList()
endfunction

function! s:VEFilePanel.visualDelete(firstLine,lastLine)
    let displayList = []
    for line in range(a:firstLine,(a:lastLine>=len(self.displayList)?(len(self.displayList)-1):a:lastLine))
        let path = self.displayList[line][1]
        if path == ''
            continue
        endif
        call add(displayList,path)
    endfor
    if empty(displayList)
        return
    endif
    if g:VEPlatform.deleteMultiple(displayList)
        call self.refresh()
    endif
endfunction

function! s:VEFilePanel.visualYank(firstLine,lastLine,mode)
    let displayList = []
    for line in range(a:firstLine,(a:lastLine>=len(self.displayList)?(len(self.displayList)-1):a:lastLine))
        let path = self.displayList[line][1]
        if path == ''
            continue
        endif
        call add(displayList,path)
    endfor
    if empty(displayList)
        return
    endif
    let winName = matchstr(bufname("%"),'_[^_]*$')
    let s:VEContainer.yankMode = a:mode
    let s:VEContainer.clipboard = displayList
    call s:VEContainer.showClipboard()
endfunction

function! s:VEFilePanel.yankSingle(mode)
    let line = line(".") - 1
    let path = self.displayList[line][1]
    if path != ''
        let s:VEContainer.yankMode = a:mode
        let s:VEContainer.clipboard = []
        call add(s:VEContainer.clipboard,path)
    endif
    call s:VEContainer.showClipboard()
endfunction

function! s:VEFilePanel.paste()
    if s:VEContainer.yankMode == '' || s:VEContainer.clipboard == []
        return
    endif
    let retList = g:VEPlatform.copyMultiFile(s:VEContainer.clipboard,self.path)
    if s:VEContainer.yankMode == 'cut' && len(retList) != 0
        for i in retList
            call g:VEPlatform.delete(i)
        endfor
        let s:VEContainer.yankMode = ''
        let s:VEContainer.clipboard = []
    endif
    call self.refresh()
    "call s:VEContainer.showClipboard()
endfunction!

function! s:VEFilePanel.markViaRegexp(regexp)
    if a:regexp == ''
        echohl Special
        let regexp = input("Mark files (regexp): ")
        echohl None
    else
        let regexp = a:regexp
    endif
    let self.selectedFiles = []
    for i in self.displayList
        if g:VEPlatform.haswin32() && !&ssl
            let name = matchstr(i[1],'[^\\]*.$','','g')
        else
            let name = matchstr(i[1],'[^/]*.$','','g')
        endif
        if matchstr(name,regexp) != ''
            call add(self.selectedFiles,i[1])
        endif
    endfor
    call self.drawList()
endfunction

function! s:VEFilePanel.markExecutable()
    let self.selectedFiles = []
    for i in self.displayList
        if g:VEPlatform.executable(i[1])
            call add(self.selectedFiles,i[1])
        endif
    endfor
    call self.drawList()
endfunction

function! s:VEFilePanel.newFile()
    echohl Special
    let filename = input("Create file : ",self.path,"file")
    echohl None
    if filename == ''
        echo " "
        return
    endif
    if g:VEPlatform.mkfile(filename)
        echohl Special | echomsg "OK" | echohl None
        call self.refresh()
    else
        echohl ErrorMsg | echomsg "Can not create file!" | echohl None
    endif
endfunction

function! s:VEFilePanel.newDirectory()
    if !exists("*mkdir")
        echoerr "mkdir feature not found!"
    endif
    echohl Special
    let dirname = input("Create directory : ",self.path,"file")
    echohl None
    if dirname == ''
        echo " "
        return
    endif
    if findfile(dirname) == '' && g:VEPlatform.mkdir(dirname)
        echohl Special | echomsg "OK" | echohl None
        call self.refresh()
    else
        echohl ErrorMsg | echomsg "Can not create directory!" | echohl None
    endif
endfunction

function! s:VEFilePanel.rename(line)
    let path = self.displayList[a:line][1]
    if path == ''
        return
    endif
    echohl Special
    let name = input("Rename to: ",path,"file")
    echohl None
    if name == ''
        echo " "
        return
    endif
    if findfile(name) != ''
        echohl ErrorMsg | echomsg "File exists!" | echohl None
        return
    endif
    if rename(path,name) == 0
        echohl Special | echomsg "OK" | echohl None
        call self.refresh()
    else
        echohl ErrorMsg | echomsg "Can not rename!" | echohl None
    endif
endfunction

function! s:VEFilePanel.search()
    echohl Special
    let filename = input("Search : ")
    echohl None
    if filename == ''
        echo " "
        return
    endif
    echohl Special | echomsg "Searching [" . filename . "] in " . self.path . ", please wait...(Ctrl-C to break)" | echohl None
    let self.fileList = g:VEPlatform.search(filename,self.path)
    call self.updateDisplayList()
    call self.drawList()
endfunction

function! s:VEFilePanel.statusFileName()
    let line = line(".") - 1
    let fname = self.displayList[line][1]
    "let fname = substitute(fname,self.path,'','g')
    let fname = fname[len(self.path):]
    return fname
endfunction

function! s:VEFilePanel.createActions()
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.help .           " :tab h VimExplorer<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.switchPanel .    " <c-w><c-w>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.itemClicked .    " :call VE_OnFileItemClick()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.itemClickMouse.  " :call VE_OnFileItemClick()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toggleTreePanel ." :call VE_ToggleTreePanel()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toUpperDir .     " :call VE_ToUpperDir()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.gotoForward .    " :call VE_GotoForward()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.gotoBackward .   " :call VE_GotoBackward()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.openPreview .    " :call VE_OnFileOpenPreview()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.closePreview .   " :call VE_ClosePreviewPanel()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.deleteSingle .   " :call VE_DeleteSingle()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.rename .         " :call VE_Rename()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.refresh .        " :call VE_RefreshFilePanel()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toggleSelectUp  ." :call VE_ToggleSelectFile(\"up\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toggleSelectDown." :call VE_ToggleSelectFile(\"down\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.clearSelect .    " :call VE_ClearSelectFile()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.deleteSelected . " :call VE_DeleteSelectedFiles()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.yankSelected .   " :call VE_YankSelectedFiles(\"copy\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.cutSelected .    " :call VE_YankSelectedFiles(\"cut\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.yankSingle .     " :call VE_YankSingle(\"copy\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.cutSingle .      " :call VE_YankSingle(\"cut\")<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.showYankList .   " :call VE_ShowYankList()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toggleModes .    " :call VE_ToggleModes()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.paste .          " :call VE_Paste()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markViaRegexp .  " :call VE_MarkViaRegexp('')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markExecutable . " :call VE_MarkExecutable()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markVimFiles .   " :call VE_MarkViaRegexp('.*.vim$')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markDirectory .  " :call VE_MarkViaRegexp('.*[\\/]$')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.newFile .        " :call VE_NewFile()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.newDirectory .   " :call VE_NewDirectory()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markViaRegexp .  " :call VE_MarkViaRegexp('')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.favorite .       " :call VE_GotoFavorite()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.addToFavorite .  " :call VE_AddToFavorite('filePanel')<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.browseHistory .  " :call VE_BrowseHistory()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.gotoPath .       " :call VE_OpenPath()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.diff2files .     " :call VE_Diff()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.quitVE .         " :call VEDestroy()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.toggleHidden .   " :call VE_ToggleHidden()<cr>"
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.search .         " :call VE_FileSearch()<cr>"

    let letter = char2nr('a')
    while letter <= char2nr('z')
        exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.markPlace . nr2char(letter) .
                    \" :call VE_MarkPlace(\"" . nr2char(letter) . "\")<cr>"
        exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.gotoPlace . nr2char(letter) .
                    \" :call VE_MarkSwitchTo(\"" . nr2char(letter) . "\")<cr>"
        let letter = letter + 1
    endwhile
    exec "nnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.viewMarks . " :call VE_MarkList()<cr>"

    " visual mode map
    exec "vnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.visualSelect .   " :call VE_VisualSelect()<cr>"
    exec "vnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.visualDelete .   " :call VE_VisualDelete()<cr>"
    exec "vnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.visualYank .     " :call VE_VisualYank(\"copy\")<cr>"
    exec "vnoremap <silent> <buffer> " . g:VEConf.filePanelHotkey.visualCut .      " :call VE_VisualYank(\"cut\")<cr>"

    " User defined map
    for i in keys(g:VEConf_normalHotKeys)
        exec "nnoremap <silent> <buffer> " . g:VEConf_normalHotKeys[i] .
                    \" :call VE_NormalAction(\"" . i . "\")<cr>"
    endfor
    for i in keys(g:VEConf_singleFileHotKeys)
        exec "nnoremap <silent> <buffer> " . g:VEConf_singleFileHotKeys[i] .
                    \" :call VE_SingleFileAction(\"" . i . "\")<cr>"
    endfor
    for i in keys(g:VEConf_multiFileHotKeys)
        exec "nnoremap <silent> <buffer> " . g:VEConf_multiFileHotKeys[i] .
                    \" :call VE_MultiFileAction(\"" . i . "\")<cr>"
    endfor
    " Auto commands
    au! * <buffer>
    au BufEnter <buffer>  call VE_SyncDir()
    " Status line
    setlocal statusline=%{VE_GetStatusFileName()}%=[%{getcwd()}]\ %{strftime(\"\%Y-\%m-\%d\ \%H:\%M\")}
endfunction

function! s:VEFilePanel.createSyntax()
    let VEFileWinNr = bufwinnr(self.name)
    if VEFileWinNr != -1
        exec VEFileWinNr . " wincmd w"
    else
        return
    endif
    call g:VEConf.filePanelSyntax()
endfunction

function! s:VEFilePanel.getPathUnderCursor(num)
    return self.displayList[a:num][1]
endfunction

" class VEPreviewPanel {{{1
"=============================
"let s:VEPreviewPanel = {}
"let s:VEPreviewPanel.name = ''
"let s:VEPreviewPanel.width = 0
"let s:VEPreviewPanel.splitMode = ''
"let s:VEPreviewPanel.splitLocation = ''
"
"function! s:VEPreviewPanel.init(name)
"    let self.name = "VEPreviewPanel" . a:name
"    let self.width = g:VEConf.previewPanelWidth
"    let self.splitMode = g:VEConf.previewPanelSplitMode
"    let self.splitLocation = g:VEConf.previewPanelSplitLocation
"endfunction

"function! s:VEPreviewPanel.show()
"    if self.setFocus()
"        return
"    endif
"    let cmd = self.splitLocation . " " . self.splitMode . self.width . ' new '
"    exec cmd
"    if !self.setFocus()
"        echoerr "create file window failed!"
"    else
"        edit self.name
"    endif
"endfunction

"function! s:VEPreviewPanel.setFocus()
"    let VEPreviewWinNr = bufwinnr(self.name)
"    if VEPreviewWinNr != -1
"        exec VEPreviewWinNr . " wincmd w"
"        return 1
"    else
"        "If the window of buffer was closed by hand and the
"        "buffer still in buffer list, wipeout it.
"        "In case of bufnr() returns empty when there are two
"        "buffers have the same name.
"        let bufNr = bufnr(self.name)
"        if bufNr != -1
"            exec "bwipeout " . bufNr
"        endif
"        return 0
"    endif
"endfunction
"
"function! s:VEPreviewPanel.hide()
"    if !self.setFocus()
"        return
"    else
"        let bufNr = bufnr('%')
""        exec "wincmd c"
"        exec "bwipeout ".bufNr
"    endif
"endfunction
"
"function! s:VEPreviewPanel.preview(path)
"    if !self.setFocus()
"        let self.name = a:path
"        let cmd = self.splitLocation . " " . self.splitMode . self.width . ' new'
"        exec cmd
"        exec "edit " . self.name
"        return
"    else
"        let self.name = a:path
"        exec "edit " . self.name
"    endif
"endfunction



" class VEFrameWork {{{1
"=============================
let s:VEFrameWork = {}
let s:VEFrameWork.name = ''
let s:VEFrameWork.treePanel = {}
let s:VEFrameWork.filePanel = {}
"let s:VEFrameWork.previewPanel = {}
let s:VEFrameWork.pathHistory = []
let s:VEFrameWork.pathPosition = -1

"Object Constructor
function! s:VEFrameWork.init(name,path)
    let self.name = "VEFrameWork".a:name
    let self.filePanel = deepcopy(s:VEFilePanel)
    let self.treePanel = deepcopy(s:VETreePanel)
    "let self.previewPanel = deepcopy(s:VEPreviewPanel)
    call self.filePanel.init(a:name,a:path)
    call self.treePanel.init(a:name,a:path)
    "call self.previewPanel.init(a:name)
    call add(self.pathHistory,a:path)
    let self.pathPosition += 1
endfunction

function! s:VEFrameWork.show()
    tabnew
    call self.filePanel.show()
    call self.filePanel.only() "so,here it means filePanel should be displayed first
    call self.treePanel.show()
    call self.filePanel.setFocus()
    call self.filePanel.refresh()
    normal! M
endfunction

"Switch to another path, it will change the forward/backward
"history.
function! s:VEFrameWork.gotoPath(path)
    call self.treePanel.pathChanged(a:path)
    call self.filePanel.pathChanged(a:path)
    if len(self.pathHistory) > self.pathPosition+1
        call remove(self.pathHistory,self.pathPosition+1,-1)
    endif
    call add(self.pathHistory,a:path)
    if len(self.pathHistory) > g:VEConf.browseHistory
        call remove(self.pathHistory,0)
    else
        let self.pathPosition += 1
    endif
endfunction

"Forward and backward
function! s:VEFrameWork.gotoForward()
    if self.pathPosition >= len(self.pathHistory) ||
                \ self.pathPosition < 0 ||
                \ empty(self.pathHistory)
        return
    endif
    if self.pathPosition+1 == len(self.pathHistory) "Can not forward
        return
    endif
    let self.pathPosition += 1
    "Do not call VE_GotoPath here! It will change pathHistory.
    "Call the follows instead.
    call self.treePanel.pathChanged(self.pathHistory[self.pathPosition])
    call self.filePanel.pathChanged(self.pathHistory[self.pathPosition])
endfunction

function! s:VEFrameWork.gotoBackward()
    if self.pathPosition >= len(self.pathHistory) ||
                \ self.pathPosition < 0 ||
                \ empty(self.pathHistory)
        return
    endif
    if self.pathPosition == 0 "Can not go back.
        return
    endif
    let self.pathPosition -= 1
    "Do not call VE_GotoPath here! It will change pathHistory.
    "Call the follows instead.
    call self.treePanel.pathChanged(self.pathHistory[self.pathPosition])
    call self.filePanel.pathChanged(self.pathHistory[self.pathPosition])
endfunction

"Object destructor
function! s:VEFrameWork.destroy()
    call self.filePanel.hide()
    call self.treePanel.hide()
endfunction






"####################################################
"global variables and functions {{{1

let s:VEContainer = {} "contains all VEFrameWorks
let s:VEContainer.clipboard = [] "shared clipboard
let s:VEContainer.yankMode = ''  "cut or yank
let s:VEContainer.markPlaces = {}

function! VENew(path)
    let frameName = '_' . substitute(reltimestr(reltime()),'\.','','g')
    if a:path == ''
        echohl Special
        let workPath = input("VimExplorer (directory): ",g:VEPlatform.getcwd(),"file")
        echohl None
        if workPath == ''
            return
        endif
    else
        let workPath = a:path
    endif
    call g:VEPlatform.cdToPath(workPath)
    let workPath = g:VEPlatform.getcwd() "Conversions capitalisations
    "does not work here.
    if !isdirectory(workPath)
        echohl ErrorMsg | echomsg "Directory not exist!" | echohl None
        return
    endif
    let s:VEContainer[frameName] = deepcopy(s:VEFrameWork)
    call s:VEContainer[frameName].init(frameName,workPath)
    call s:VEContainer[frameName].show()
    let letter = char2nr('a')
    while letter <= char2nr('z')
        let s:VEContainer.markPlaces[nr2char(letter)] = ''
        let letter = letter + 1
    endwhile
endfunction

function! VEDestroy()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].destroy()
        call remove(s:VEContainer,winName)
    endif
endfunction

function! s:VEContainer.showClipboard()
    echohl Special
    let msg = len(self.clipboard) . " files in clipboard, Mode: " . self.yankMode . ", "
    let msg = msg . '(press ' . g:VEConf.filePanelHotkey.showYankList . ' to show file list)'
    echomsg msg
    echohl None
endfunction

" Get path name under cursor
function! VE_getPathUnderCursor(where)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    let path = ''
    if has_key(s:VEContainer,winName)
        if a:where == 'treePanel'
            let path = s:VEContainer[winName].treePanel.getPathUnderCursor(line(".")-1)
        elseif a:where == 'filePanel'
            let path = s:VEContainer[winName].filePanel.getPathUnderCursor(line(".")-1)
        endif
    endif

    if !isdirectory(path)
        return ''
    else
        return path
    endif
endfunction


"Command handlers
"===================================

"TreePanel command handlers
"----------------------------
"Node click event
function! VE_OnTreeNodeClick()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].treePanel.nodeClicked(line(".")-1)
    endif
endfunction

"Refresh tree command
function! VE_TreeRefresh()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].treePanel.refresh()
    endif
endfunction

"FilePanel command handlers
"----------------------------
"Item click event.
function! VE_OnFileItemClick()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.itemClicked(line(".")-1)
    endif
endfunction

"Open preview.
function! VE_OnFileOpenPreview()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.itemPreview(line(".")-1)
    endif
endfunction

"Refresh the panel.
function! VE_RefreshFilePanel()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.refresh()
    endif
endfunction

"User defined single file actions.
function! VE_SingleFileAction(actionName)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.singleFileAction((line(".")-1),a:actionName)
    endif
endfunction

"User defined normal actions.
function! VE_NormalAction(actionName)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.normalAction(a:actionName)
    endif
endfunction

"Multiple file actions.
function! VE_MultiFileAction(actionName)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.multiAction(a:actionName)
    endif
endfunction

"Delete single file or directory.
function! VE_DeleteSingle()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.deleteSingle(line(".")-1)
    endif
endfunction

"Rename file or dir
function! VE_Rename()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.rename(line(".")-1)
    endif
endfunction

"Toggle select a file in file panel.
function! VE_ToggleSelectFile(direction)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.toggleSelect(a:direction)
    endif
endfunction

"Clear selection.
function! VE_ClearSelectFile()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.clearSelect()
    endif
endfunction

"Toggle sort mode
function! VE_ToggleModes()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.toggleModes()
    endif
endfunction

"Mark via regexp
function! VE_MarkViaRegexp(regexp)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.markViaRegexp(a:regexp)
    endif
endfunction

"Mark executable files.
function! VE_MarkExecutable()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.markExecutable()
    endif
endfunction

"create file
function! VE_NewFile()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.newFile()
    endif
endfunction

"create directory
function! VE_NewDirectory()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.newDirectory()
    endif
endfunction

"delete selected files.
function! VE_DeleteSelectedFiles()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.deleteSelectedFiles()
    endif
endfunction

"delete selected files.
function! VE_YankSelectedFiles(mode)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let s:VEContainer.clipboard = s:VEContainer[winName].filePanel.selectedFiles
        let s:VEContainer.yankMode = a:mode
    endif
    call s:VEContainer.showClipboard()
endfunction

function! VE_YankSingle(mode)
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.yankSingle(a:mode)
    endif
endfunction

function! VE_Paste()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.paste()
    endif
endfunction

function! VE_FileSearch()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.search()
    endif
endfunction


"visual mode functions.
"visual select
function! VE_VisualSelect() range
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.visualSelect(a:firstline-1,a:lastline-1)
    endif
endfunction

"visual delete
function! VE_VisualDelete() range
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.visualDelete(a:firstline-1,a:lastline-1)
    endif
endfunction

"visual yank
function! VE_VisualYank(mode) range
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].filePanel.visualYank(a:firstline-1,a:lastline-1,a:mode)
    endif
endfunction

function! VE_ShowYankList()
    if s:VEContainer.clipboard == []
        return
    endif
    for i in s:VEContainer.clipboard
        echo i
    endfor
endfunction

"Common command handlers
"--------------------------
"get file name for status line.
function! VE_GetStatusFileName()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        return s:VEContainer[winName].filePanel.statusFileName()
    else
        return ''
    endif
endfunction

"mark palce
function! VE_MarkPlace(char)
    let s:VEContainer.markPlaces[a:char] = g:VEPlatform.getcwd()
endfunction

"goto marked place
function! VE_MarkSwitchTo(char)
    call VE_GotoPath(s:VEContainer.markPlaces[a:char])
endfunction

function! VE_MarkList()
    let list = []
    let letter = char2nr('a')
    while letter <= char2nr('z')
        if s:VEContainer.markPlaces[nr2char(letter)] != ''
            echo nr2char(letter) . "  " . s:VEContainer.markPlaces[nr2char(letter)]
        endif
        let letter = letter + 1
    endwhile
endfunction

"Toggle tree panel.
function! VE_ToggleTreePanel()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        if s:VEContainer[winName].treePanel.setFocus()
            call s:VEContainer[winName].treePanel.hide()
        else
            call s:VEContainer[winName].treePanel.show()
        endif
    endif
    exec "wincmd p"
endfunction

"Toggle file panel.
function! VE_ToggleFilePanel()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        if s:VEContainer[winName].filePanel.setFocus()
            call s:VEContainer[winName].filePanel.hide()
        else
            call s:VEContainer[winName].filePanel.show()
        endif
    endif
    call s:VEContainer[winName].treePanel.setFocus()
    exec g:VEConf.treePanelWidth . " wincmd |"
endfunction

function! VE_ClosePreviewPanel()
    pclose
endfunction


"Go to upper directory.
function! VE_ToUpperDir()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let path = s:VEContainer[winName].filePanel.path
        " Assert filePanel.path == treePanel.path
        let upperPath = g:VEPlatform.getUpperDir(path)
        if upperPath == path
            return
        endif
        call VE_GotoPath(upperPath)
    endif
    exec winNr . "wincmd w"
endfunction

"Path change event
function! VE_GotoPath(path)
    if !isdirectory(a:path)
        return
    endif
    call g:VEPlatform.cdToPath(a:path)
    let path = g:VEPlatform.getcwd()
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].gotoPath(path)
    endif
endfunction

"Used in <c-g>
function! VE_OpenPath()
    echohl Special
    let workPath = input("Change path to (directory): ",'',"file")
    echohl None
    if workPath == ''
        return
    endif
    call g:VEPlatform.cdToPath(workPath)
    let workPath = g:VEPlatform.getcwd()
    call VE_GotoPath(workPath)
endfunction

"Goto forward
function! VE_GotoForward()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].gotoForward()
    endif
    exec winNr . "wincmd w"
endfunction

"Goto backward
function! VE_GotoBackward()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        call s:VEContainer[winName].gotoBackward()
    endif
    exec winNr . "wincmd w"
endfunction

"Favorite
function! VE_GotoFavorite()
    let fav_filename = g:VEPlatform.getHome() . g:VEConf.favorite
    if findfile(fav_filename)=='' || !filereadable(fav_filename)
        return
    endif
    let fav = readfile(fav_filename)
    let result = g:VEPlatform.select(fav,"Favorite folder list:")
    if result == -1
        return
    endif
    call VE_GotoPath(fav[result])
endfunction

function! VE_AddToFavorite(where)
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let cwd = s:VEContainer[winName].filePanel.path
    else
        return
    endif
    let pathUnderCursor = VE_getPathUnderCursor(a:where)
    if pathUnderCursor != ''
        " if no path name under cursor, use current working path
        let cwd = pathUnderCursor
    endif
    let fav_filename = g:VEPlatform.getHome() . g:VEConf.favorite
    let fav = []
    if findfile(fav_filename) != ''
        if !filereadable(fav_filename)
            echoerr "Can not read favorite folder list!"
            return
        endif
        if !filewritable(fav_filename)
            echoerr "Can not write favorite folder list to file!"
            return
        endif
        let fav = readfile(fav_filename)
    endif
    if index(fav,cwd) != -1
        "echohl WarningMsg | echomsg "Current directory already in the favorite list." | echohl None
        echohl WarningMsg | echomsg "[ ".cwd." ] already in the favorite!" | echohl None
        return
    endif
    call add(fav,cwd)
    if writefile(fav,fav_filename) == 0
        echohl Special | echomsg "[ ".cwd." ] added to favorite." | echohl None
    else
        echoerr "Can not write favorite folder list to file!"
    endif
endfunction

"forward and backward history
function! VE_BrowseHistory()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let pathlist = s:VEContainer[winName].pathHistory
        let result = g:VEPlatform.select(pathlist,"Browse history:")
        if result == -1
            return
        else
            call s:VEContainer[winName].treePanel.pathChanged(pathlist[result])
            call s:VEContainer[winName].filePanel.pathChanged(pathlist[result])
            let s:VEContainer[winName].pathPosition = result
        endif
    endif
endfunction

"sync directory
function! VE_SyncDir()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let path = s:VEContainer[winName].filePanel.path
        call g:VEPlatform.cdToPath(path)
    endif
endfunction

"diff 2 files
function! VE_Diff()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let diffFiles = s:VEContainer[winName].filePanel.selectedFiles
        if len(diffFiles) != 2 || isdirectory(diffFiles[0]) || isdirectory(diffFiles[1])
            echohl WarningMsg | echo "Please select 2 files to diff!" | echohl None
            return
        endif
        exec "tabe " . g:VEPlatform.escape(diffFiles[0])
        exec "vertical diffsplit " . g:VEPlatform.escape(diffFiles[1])
    endif
endfunction

"toggle show hidden files
function! VE_ToggleHidden()
    let winNr = bufwinnr('%')
    let winName = matchstr(bufname("%"),'_[^_]*$')
    if has_key(s:VEContainer,winName)
        let g:VEConf.showHiddenFiles = !g:VEConf.showHiddenFiles
        call s:VEContainer[winName].treePanel.refresh()
        call s:VEContainer[winName].filePanel.refresh()
    endif
endfunction

command! -nargs=? -complete=file VE    call VENew('<args>')
command! -nargs=0 -complete=file VEC   call VEDestroy()


"====================================================================
"
" Function: s:InstallDocumentation(full_name, revision)
"   Install help documentation.
" Arguments:
"   full_name: Full name of this vim plugin script, including path name.
"   revision:  Revision of the vim script. #version# mark in the document file
"              will be replaced with this string with 'v' prefix.
" Return:
"   1 if new document installed, 0 otherwise.
" Note: Cleaned and generalized by guo-peng Wen.
"
" Note about authorship: this function was taken from the vimspell plugin
" which can be found at http://www.vim.org/scripts/script.php?script_id=465
"
function! s:InstallDocumentation(full_name, revision)
    " Name of the document path based on the system we use:
    if has("vms")
         " No chance that this script will work with
         " VMS -  to much pathname juggling here.
         return 1
    elseif (has("unix"))
        " On UNIX like system, using forward slash:
        let l:slash_char = '/'
        let l:mkdir_cmd  = ':silent !mkdir -p '
    else
        " On M$ system, use backslash. Also mkdir syntax is different.
        " This should only work on W2K and up.
        let l:slash_char = '\'
        let l:mkdir_cmd  = ':silent !mkdir '
    endif

    let l:doc_path = l:slash_char . 'doc'
    let l:doc_home = l:slash_char . '.vim' . l:slash_char . 'doc'

    " Figure out document path based on full name of this script:
    let l:vim_plugin_path = fnamemodify(a:full_name, ':h')
    let l:vim_doc_path    = fnamemodify(a:full_name, ':h:h') . l:doc_path
    if (!(filewritable(l:vim_doc_path) == 2))
         "Doc path: " . l:vim_doc_path
        echo "Doc path: " . l:vim_doc_path
        execute l:mkdir_cmd . '"' . l:vim_doc_path . '"'
        if (!(filewritable(l:vim_doc_path) == 2))
            " Try a default configuration in user home:
            let l:vim_doc_path = expand("~") . l:doc_home
            if (!(filewritable(l:vim_doc_path) == 2))
                execute l:mkdir_cmd . '"' . l:vim_doc_path . '"'
                if (!(filewritable(l:vim_doc_path) == 2))
                    " Put a warning:
                    echo "Unable to open documentation directory"
                    echo "type :help add-local-help for more information."
                    echo l:vim_doc_path
                    return 0
                endif
            endif
        endif
    endif

    " Exit if we have problem to access the document directory:
    if (!isdirectory(l:vim_plugin_path) || !isdirectory(l:vim_doc_path) || filewritable(l:vim_doc_path) != 2)
        return 0
    endif

    " Full name of script and documentation file:
    let l:script_name = fnamemodify(a:full_name, ':t')
    let l:doc_name    = fnamemodify(a:full_name, ':t:r') . '.txt'
    let l:plugin_file = l:vim_plugin_path . l:slash_char . l:script_name
    let l:doc_file    = l:vim_doc_path    . l:slash_char . l:doc_name

    " Bail out if document file is still up to date:
    if (filereadable(l:doc_file) && getftime(l:plugin_file) < getftime(l:doc_file))
        return 0
    endif

    " Prepare window position restoring command:
    if (strlen(@%))
        let l:go_back = 'b ' . bufnr("%")
    else
        let l:go_back = 'enew!'
    endif

    " Create a new buffer & read in the plugin file (me):
    setl nomodeline
    exe 'enew!'
    exe 'r ' . l:plugin_file

    setl modeline
    let l:buf = bufnr("%")
    setl noswapfile modifiable

    norm zR
    norm gg

    " Delete from first line to a line starts with
    " === START_DOC
    1,/^=\{3,}\s\+START_DOC\C/ d

    " Delete from a line starts with
    " === END_DOC
    " to the end of the documents:
    /^=\{3,}\s\+END_DOC\C/,$ d

    " Add modeline for help doc: the modeline string is mangled intentionally
    " to avoid it be recognized by VIM:
    call append(line('$'), '')
    call append(line('$'), ' v' . 'im:tw=78:ts=8:ft=help:norl:')

    " Replace revision:
    "exe "normal :1s/#version#/ v" . a:revision . "/\<CR>"
    exe "normal :%s/#version#/ v" . a:revision . "/\<CR>"

    " Save the help document:
    exe 'w! ' . l:doc_file
    exe l:go_back
    exe 'bw ' . l:buf

    " Build help tags:
    exe 'helptags ' . l:vim_doc_path

    return 1
endfunction

" Doc installation call {{{1
silent call s:InstallDocumentation(expand('<sfile>:p'),"0.98")
"============================================================
finish

"Manual {{{1
=== START_DOC
*VimExplorer*          A powerful file manager              #version#


                     VimExplorer Reference Manual
                  by Ming Bai (mbbill AT gmail.com)


==============================================================================
CONTENTS                                        *VimExplorer-contents*

1.  Intro.......................................|VimExplorer-start|
2.  Functionality...............................|VimExplorer-functionality|
    2.1  Tree Panel Hotkeys.....................|VimExplorer-treehotkey|
    2.2  File Panel Hotkeys.....................|VimExplorer-filehotkey|
    2.3  Commands...............................|VimExplorer-commands|
3.  Directory Browsing..........................|VimExplorer-browse|
    3.1  Tree Browsing..........................|VimExplorer-treebrowse|
    3.2  File Browsing..........................|VimExplorer-filebrowse|
    3.3  Forward and Backward...................|VimExplorer-forbackward|
    3.4  Favorites..............................|VimExplorer-favorite|
    3.5  Temp Marks.............................|VimExplorer-tempmark|
4.  Marks.......................................|VimExplorer-mark|
    4.1  Single File Marks......................|VimExplorer-marksingle|
    4.2  Visual Marks...........................|VimExplorer-markvisual|
    4.3  Regexp Marks...........................|VimExplorer-markregexp|
5.  File operations.............................|VimExplorer-fileoperation|
    5.1  Create.................................|VimExplorer-new|
    5.2  Move...................................|VimExplorer-move|
    5.3  Delete.................................|VimExplorer-delete|
    5.4  Diff...................................|VimExplorer-diff|
    5.5  Search.................................|VimExplorer-search|
    5.6  Other Operations.......................|VimExplorer-otherfileopt|
6.  Other Functionalities.......................|VimExplorer-otherfuncs|
7.  Customization...............................|VimExplorer-customize|
    7.1  Normal Options.........................|VimExplorer-custnormal|
    7.2  Hotkey Customization...................|VimExplorer-custhotkey|
    7.3  Command Customization..................|VimExplorer-custcommand|
8.  The Author..................................|VimExplorer-author|
9.  Problems and Fixes..........................|VimExplorer-problems|
10. Changelog...................................|VimExplorer-changelog|
11. TODO........................................|VimExplorer-todo|


==============================================================================
1.  Intro                                       *VimExplorer-start*

What is VimExplorer ?
VimExplorer is a file manager, it can do a lot of file operations such as
copy, delete, move, preview, search and so on. Also it has a variety of other
capacities and customization abilities.

You can start VimExplorer by the following command:
>
        :VE
<
Then it will ask you for the starting directory, default is the current path.
>
        VimExplorer (directory): /home/username/
<
You can change it to some other directories or just push "Enter" to start it.

The second approach to start VimExplorer:
>
        :VE [directory]
<
Example:
>
        :VE /usr/src/
<
Now, VimExplorer will start using the path '/usr/src/'. When you are typing
the path, <tab> and <ctrl-d> will help you to complete the path automatically.
After all of these operations, you can see a new tab which has two panels
within it, one is the "Tree Panel" and the other is "File Panel". From now you
will have a happy journey using the powerful file manager.


==============================================================================
2.  Functionality                               *VimExplorer-functionality*

2.1  Tree Panel Hotkeys                         *VimExplorer-treehotkey*

Member of |VEConf_treeHotkey|, refer to section 7.2 .

Mapping                        Key             Description~
help                    ?               Help.
toggleNode              <cr>            Open/Close/Switch to current node.
toggleNodeMouse         <2-LeftMouse>   Open/Close/Switch to current node.
refresh                 r               Refresh the tree panel.
favorite                f               View favorite folder list.
addToFavorite           F               Add the folder under cursor to
                                        favorite list. If no path under
                                        cursor, use current working path.
browseHistory           b               View browse history.
toggleFilePanel         t               Toggle the file panel.
toUpperDir              <bs>            Go to upper directory.
switchPanel             <c-tab>         Switch to File Panel.
gotoPath                <c-g>           Change to another path.
quitVE                  Q               Quit VimExplorer.

2.2  File Panel Hotkeys                         *VimExplorer-filehotkey*

Member of |VEConf_fileHotkey|, refer to section 7.2 .

Mapping                 Default         Description~
help                    ?               Help.
itemClicked             <cr>            Enter the directory or open the file
                                        by default association.
itemClickMouse          <2-LeftMouse>   Enter the directory or open the file
                                        by default association.
refresh                 r               Refresh.
toggleTreePanel         t               Toggle the Tree Panel.
toggleModes             i               Toggle file sort mode (type/data/file
                                        extension).
newFile                 +f              Create a new file.
newDirectory            +d              Create a new directory.
switchPanel             <c-tab>         Switch to the Tree Panel.
quitVE                  Q               Quit VimExplorer.
toggleHidden            H               Toggle show hidden files.(files start
                                        with '.')
search                  g/              Search.
markPlace               m{a-z}          Put current path to register(a-z).
gotoPlace               '{a-z}          Jump to path in register(a-z).
viewMarks               J               View path in register.
toUpperDir              <bs>            Go to upper directory.
gotoForward             <c-i>           Forward.
gotoBackward            <c-o>           Backward.
favorite                f               View favorite folder list.
addToFavorite           F               Add the folder under cursor to
                                        favorite list. If no path under
                                        cursor, use current working path.
browseHistory           b               View browse history.
gotoPath                <c-g>           Change to another path.
rename                  R               Rename the file under cursor.
yankSingle              yy              Copy file under cursor.
cutSingle               xx              Cut file under cursor.
showYankList            yl              Show clipboard.
deleteSingle            dd              Delete file under cursor.
openPreview             u               Preview.
closePreview            U               Close the preview panel.
toggleSelectUp          <s-space>       Move the cursor up and mark/unmark the
                                        file under cursor.
toggleSelectDown        <space>         Mark/unmark the file under cursor and
                                        move the cursor down.
markViaRegexp           Mr              Mark via regular expression.
markVimFiles            Mv              Mark all vim files.
markDirectory           Md              Mark all directories.
markExecutable          Me              Mark all executable files.
clearSelect             Mc              Clear all marks.
deleteSelected          sd              Delete marked files.
yankSelected            sy              Copy marked files.
cutSelected             sx              Cut marked files.
tabViewMulti            se              Edit every marked file in separate
                                        tabs.
paste                   p               Paste.
diff2files              =               Diff two files.
tabView                 e               Edit file in new tab.
openRenamer             ;r              Open Renamer (Note 1)
startShell              ;c              Start a shell from current path.
startExplorer           ;e              Start another file
                                        manager(nautilus,konquer,explorer.exe).

Visual Mode Hotkeys~
visualSelect            <space>         Mark files.
visualDelete            d               Delete files.
visualYank              y               Copy files.
visualCut               x               Cut files.
tabView                 e               View files in new tabs.

2.3  Commands                                   *VimExplorer-commands*
>
    VE
<
Start VimExplorer.

>
    VEC
<
Close VimExplorer, Hotkey |Q| has the same ability.

==============================================================================
3.  Directory Browsing                          *VimExplorer-browse*

3.1  Tree Browsing                              *VimExplorer-treebrowse*

Press "Enter" on one tree node will change the path and add the new path to
browse history. By default, if a directory has it's own child directories, |+|
will be displayed before it's name, and It will cause a little performance
lost.  If you don't need this feature ,set the following variable to zero can
disable it.
>
    let VEConf_showFolderStatus = 0
<
There are some differences between win32 and other platforms. In win32, there
are several root nodes (such as C:\,D:\), but one root node (/) in other
platforms.

3.2  File Browsing                              *VimExplorer-filebrowse*

The file panel consist of two parts: the path in the top and the following
file list. Every line of the file list consist from the following regions:

[*] {file-name}         [file-size] {permission} {modify-time}

The file panel can sort by type, file name and date. Hotkey |i| is used to
cycle between these modes. Default sort mode controlled by following variable:
>
    VEConf_filePanelSortType

<
See Customization section for more details.

3.3  Forward and Backward                       *VimExplorer-forbackward*

When using "Enter" switch to an new folder, the path will be add to browse
history. Then you can use |<c-o>| and |<c-i>| to go backward and forward.
Hotkey |b| is used to list all browse history, select by number or mouse can
take you directory to that path.

By default, the depth of browse history is 100. Controled by this variable:
>
    VEConf_browseHistory
<

3.4  Favorites                                  *VimExplorer-favorite*

The favorite folder list is saved to the file $HOME/.ve_favorite . It will be
updated when new folder is added to favorite by hotkey |F|. The format of
".ve_favorite" is very simple: every line is a path, so edit it is quite
easy.

3.5  Temp Marks                                 *VimExplorer-tempmark*

Just like the favorites, |ma| put current path into register 'a', and |'a| can
jump to the path. |J| is used to list every non empty register. All paths in
register will disappear after VimExplorer exists.

==============================================================================
4.  Marks                                       *VimExplorer-mark*

The simplest way is to press <space> upon a file. There will be a '*' before
marked files and also be displayed in a different color.
There are three way to mark files:

4.1  Single File Marks                          *VimExplorer-marksingle*

<space>    Invert selection, move the cursor down.
<s-space>  Move the cursor up, then invert selection.
Just like most of vim commands, 5<space> will mark 5 files start from current
cursor.

4.2  Visual Marks                               *VimExplorer-markvisual*

<space> in visual mode will invert selected these files.

4.3  Regexp Marks                               *VimExplorer-markregexp*

Hotkey: |Mr|
Only the file name is the target of regexp match. Example:
>
    Mark file (regexp): ^abc.*\.vim$
<
It will mark all vim scripts start with abc. The following functionalities is
derived from this feature:
|Mv|  mark all vim scripts.
|Me|  mark all executable files.
|Md|  mark all directories.
and |Mc| to clear all marks.

==============================================================================
5.  File Operations                             *VimExplorer-fileoperation*

5.1  Create                                     *VimExplorer-new*

|+f| and |+d| is used to create new files and directories.

5.2  Move                                       *VimExplorer-move*

There are several hotkey used to copy/cut files:
|yy| and |sy| in normal mode ,|y| in visual mode is to copy file.
|xx| and |sx| in normal mode ,|x| in visual mode is to cut file.
|p| paste file.
Note that the clipboard is shared between all VimExplorers ,you can cut in one
VE tab and paste in another.
If you want to view the clipboard, |yl| can be help.

5.3  Delete                                     *VimExplorer-delete*

|dd| in normal mode and |d| in visual mode. Feel good?

5.4  Diff                                       *VimExplorer-diff*

|=| is used to diff 2 files, so make sure you have selected 2 files before
using this command.

5.5  Search                                     *VimExplorer-search*

Just like / ,but the pattern here is not the regexp in vim, it will be
expended by shell.

5.6  Other Operations                           *VimExplorer-otherfileopt*

|e| |R| |u| and so on ... Refer to section 2.2

==============================================================================
6.  Other Functionalities                       *VimExplorer-otherfuncs*

|;r| |;c| |;e| and so on ...Rever to section 2.2

==============================================================================
7.  Customization                               *VimExplorer-customize*

7.1  Normal Options                             *VimExplorer-custnormal*

Common Options~

|g:VEConf_systemEncoding|           It controls the encoding of vim calling
                                    function system(). If your system encoding
                                    is different from '&encoding', set this
                                    value to system encoding.  Example: let
                                    g:VEConf_systemEncoding = 'utf-8'
                                    ,Default: '' (empty)

|g:VEConf_win32Disks|               The default value is all 26 volumes. Set this
                                    value to fit your system can increase the
                                    startup speed. If you are not using
                                    Microsoft Windows, ignore it.  Example:
                                    let VEConf_win32Disks =
                                    ["A:","B:","C:","D:"]

|g:VEConf_browseHistory|            Depth of browse history.  Default: 100

|g:VEConf_previewSplitLocation|     Split location of preview panel. Optional
                                    parameters are:
                                    "belowright","topleft","leftabove","botright".
                                    Default: "belowright"

|g:VEConf_showHiddenFiles|          Show hidden files, 1: show,0: hide. Default: 1

|g:VEConf_externalExplorer|         Name of the external file explorer. You can
                                    set this value according to you system.
                                    Default: "explorer.exe"(win32) "nautilus"
                                    (gnome)

|g:VEConf_sortCaseSensitive|        0: not case sensitive  1: case sensitive
                                    Default: 1

|g:VEConf_favorite|                 Favorite folder file name. Always stored in
                                    $HOME.  Default: ".ve_favorite"

|g:VEConf_overWriteExisting|        Ask when over write existing files.
                                    0: ask  1: always over write  2: always
                                    not over write Default: 0

|g:VEConf_usingKDE|                 If set to 1, use "kfmclient"
|g:VEConf_usingGnome|               If set to 1, use "gnome-open"

Tree Panel Options~

|g:VEConf_showFolderStatus|         It controls show '+' before the folders which
                                    have their own child folders. If it is set
                                    to 1, every folder will have a '+'.
                                    Default: 1

|g:VEConf_treePanelWidth|           Width of tree panel. Default: 30

|g:VEConf_treePanelSplitMode|       Split mode of tree panel. Default: "vertical"

|g:VEConf_treePanelSplitLocation|   Split location of tree panel, Optional
                                    parameters: "belowright" , "topleft" ,
                                    "leftabove" , "botright", Default:
                                    "leftabove"

|g:VEConf_treeSortDirection|        Sort direction. 1: A-Z  0: Z-A. Default: 1

File Panel Options~

|g:VEConf_fileGroupSortDirection|   Sort direction. 1: A-Z  0: Z-A, Default: 1

|g:VEConf_fileDeleteConfirm|        Confirm when deleting a file. 1: confirm  2:
                                    no confirm. Default: 1

|g:VEConf_filePanelWidth|           Width of file panel. Default: 40

|g:VEConf_filePanelSplitMode|       Split mode of file panel. Default: "vertical"

|g:VEConf_filePanelSplitLocation|   Split location of file panel, Optional
                                    parameters: "belowright" , "topleft" ,
                                    "leftabove" , "botright" ,Default:
                                    "leftabove"

|g:VEConf_filePanelSortType|        File sort type. 1: sort by name  2: sort by
                                    time  3: sort by type, Default: 3

|g:VEConf_showFileSizeInMKB|        1: Show file size in MKB format. 0: always
                                    show file size in byte.

|g:VEConf_filePanelFilter|          Filter of the file panel, which will be
                                    passed to glob() function. Example:
                                    let g:VEConf_filePanelFilter = '*.txt'

7.2  Hotkey Customization                       *VimExplorer-custhotkey*

All user defined hotkeys are controlled by the two dicts:
|g:VEConf_treeHotkey|    and    |g:VEConf_fileHotkey|
Example:
>
    let g:VEConf_treeHotkey = {}
    let g:VEConf_treeHotkey.help = '??'
    let g:VEConf_treeHotkey.quitVE = 'qq'
    let g:VEConf_treeHotkey.switchPanel = '<s-tab>'
<
All definable hotkeys and their default bindings refer to section 2 .

7.3.  Command Customization                     *VimExplorer-custcommand*

VimExplorer supports three types of command interface:
single file hotkeys and actions, multi file hotkeys and actions and normal
hotkeys and actions.
They are controlled by these variables:

    |VEConf_singleFileActions|    |VEConf_singleFileHotKeys|

    |VEConf_multiFileActions|     |VEConf_multiFileHotKeys|

    |VEConf_normalActions|        |VEConf_normalHotKeys|

All of them are dicts. Example:
>
    let VEConf_normalActions = {}
    let VEConf_normalHotKeys = {}
    let VEConf_normalHotKeys['test1'] = 'T1'
    function! VEConf_normalActions['test1']()
        Renamer
    endfunction
<
"test1" is the key. VimExplorer will bind the hotkey and corresponding actions
automatically.
>
    let VEConf_singleFileActions = {}
    let VEConf_singleFileHotKeys = {}
    let VEConf_singleFileHotKeys['test2'] = 'T2'
    function! VEConf_singleFileActions['test2'](path)
        call VEPlatform.system("notepad.exe " . VEPlatform.escape(a:path))
    endfunction
<
Here, parameter "path" is the path of file under cursor.
>
    let VEConf_multiFileActions = {}
    let VEConf_multiFileHotKeys = {}
    let VEConf_multiFileHotKeys['test3'] = 'T3'
    function! VEConf_multiFileActions['test3'](fileList)
        for i in a:fileList
            call VEPlatform.start("nautilus " . i)
        endfor
    endfunction
<
Parameter "fileList" consists of all paths of marked files.
In addition, VimExplorer provides some platform independent functions:
>
    VEPlatform.start(path)
    VEPlatform.system(cmd)
    VEPlatform.copyfile(filename,topath)
    VEPlatform.search(filename,path)
    VEPlatform.deleteSingle(path)
<
These functions can be used in user defined actions.




==============================================================================
8.  The Author                                  *VimExplorer-author*

If you found a bug, or have some suggestions , mail me.

mail: mbbill<AT>gmail<Dot>com

==============================================================================
9.  Problems and Fixes                          *VimExplorer-problems*

                                                *VimExplorer-p1*
P1.  Case sensitive in Win32.
     At present, the path in win32 is case sensitive. Pay attention to this
     when starting VE, editing the favorite list or using <c-g> to change
     path. A good suggestion is using <tab> or <ctrl-d> to complete path
     automatically.

                                                *VimExplorer-p2*
P2.  'wildignre' option cause some files disappeared.
     If 'wildignore' is not empty, glob() function will not return files
     matching the file pattern listed in it, then you may find some files
     disappeared in the file panel.



==============================================================================
10. Changelog                                   *VimExplorer-changelog*

0.95
    -   Initial release.

0.96
    -   Bug fix: VE_normalAction not found.

0.97
    -   Change the behaviour of hotkey 'F', now it adds the path under cursor to
        favorite list. If no path under cursor, use current working path
        instead.(Thanks to Vincent Wang)
    -   Bug fix: escape ' %#' for path.
    -   Add options |g:VEConf_usingKDE| and |g:VEConf_usingGnome| for starting
        program in *nix environment.
    -   Check if the script is already loaded, thanks to Dennis Hostetler.
    -   Change default g:VEConf_systemEncoding to '' (empty).
    -   Bug fix: favorite selection out of range.
0.98
    -   Add option VEConf_filePanelFilter.
    -   Bug fix: Escape <space> in command 'e' 'se' 'u' and '='.
    -   Bug fix: 'Cut' and 'Paste' command causes file lost.
    -   Change the default hotkey 'M' and 'B' to 'm','J'.
    -   Change forward and backward hotkey to |<c-o>| and |<c-i>|(<tab>).
    -   Change hotkey |<tab>| to |<c-tab>|.
    -   Change hotkey |mr| |mv| |md| |me| |mc| to |Mr| |Mv| |Md| |Me| |Mc|.
    -   When GUI is running, use confirm() to pop a dialog instead of input().

==============================================================================
11. TODO                                        *VimExplorer-todo*
    -   More clipboard.
    -   Diff files in different directories.
    -   Remember the cursor place when switch between directories.
    -   Two panel mode, just like TotalCommand.
    -   Diff directories.
    -   Browse via e.g. FTP, SCP ... directorys on a server.

==============================================================================
Note 1:
Renamer is a good plugin used to rename files. The author is John Orr. It can
be found here:
http://www.vim.org/scripts/script.php?script_id=1721


=== END_DOC
" vim: set et ff=unix fdm=marker sts=4 sw=4 tw=78:
