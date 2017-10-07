" Vim syntax file
" Language:     ASP.NET pages with C#
" Maintainer:   Mark Feeney <vim|AT|markfeeney|DOT|com>
" Last Change:  $Id: aspnet.vim,v 1.3 2002/04/05 16:50:03 markf Exp $
" URL:          http://www.markfeeney.com/resources/vim/syntax/aspnet_cs.vim
" Filenames:    *.aspx,*.ascx,*.asmx
"
" INSTALLATION:
"
" win32:
"       Copy this file to c:\vim\vimfiles\syntax
"       Load up a new or existing aspx/ascx/asmx file in vim
"       Give the command: :set syn=aspnet
"
" Unix-ish:
"       Copy this file to ~/.vim/syntax and follow the win32 insturctions
"
" It doesn't work!
"       Try running the following commands from in vim, or add them to your
"       vimrc file:
"       :syn enable
"       :colorscheme pablo (or any colorscheme)
"       :set syn=aspnet
"
" NOTES:
"   This is pretty primitive at the moment, and only supports C#.  It should
"   be easy to add VB.NET and JScript.NET when/if some decent .vim syntax
"   files for those appear.
"
" OPTIONS:
"   None yet.
"
" CREDITS:
"   The original version of aspnet.vim was written by Mark Feeney.
"   Inspiration and help came from Johannes Zellner's cs.vim that comes with
"   the standard Vim distro, as well as Lutz Eymers' php.vim and Devin
"   Weaver's aspvbs.vim script.
"
" REFERENCES:
"   [1] .NET Framework Documentation that comes with the SDK
"
" TODO:
"   - Date format highlighting within FMT= (maybe)
"
" KNOWN BUGS:
"   The ending </script> tag for <script runat="server"> ... </script> blocks
"   doesn't hilight properly (compared to the opening tag).  There was no
"   obvious reason why, and everything else seemed ok, so that's that.  If
"   anyone fixes this up, please let me know.
"

" Quit when a syntax file was already loaded
if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'aspnet'
endif

syn include @aspnetAddCS $VIMRUNTIME/syntax/cs.vim
unlet b:current_syntax

"
" This bit isn't very portable -- it just adds my custom additions to the
" standard c# syntax file.  Basically just some folds.
"
syn include @myCSStuff <sfile>:p:h/../after/syntax/cs.vim
syn cluster aspnetAddCS add=@myCSStuff

if version < 600
  source <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
endif
unlet b:current_syntax

syn cluster htmlPreProc add=aspnetServerScript,aspnetSpecialTag,aspDataBindRegion

" ASP.NET Tags
" EXAMPLE:
" <%@ Page Langauge="C#" %>
"
syn region aspnetSpecialTag contained keepend extend matchgroup=Function start=+<%+ end=+%>+ contains=aspnetDirective,aspnetAttribute,aspnetSpecialTagPunct,aspnetDataBindRegion
syn match aspnetSpecialTagPunct contained       +[@"'=]+

" Data binding syntax
" EXAMPLE:
" <%# Container.DataItem %>
"""syn region aspnetDataBindRegion keepend contained matchgroup=Function start=+<%#+ end=+%>+ contains=@aspnetAddCS,aspnetDataBindRegionPunct
syn match aspnetDataBindRegion contained +#[^"']\+\.*+ contains=@aspnetAddCS,aspnetDataBindRegionPunct display
syn match aspnetDataBindRegionPunct contained +#+

" @ directives
" NOTE: we skip over highlighting the @ and use aspnetSpecialTagPunct to give it a
"       different colour.
syn match aspnetDirective contained     +@\s*\(Page\|Control\|Import\|Implements\|Register\|Assembly\|OutputCache\|Reference\)+hs=s+1 contains=aspnetSpecialTagPunct
syn keyword aspnetAttribute contained   AspCompat AutoEventWireup Assembly Buffer
syn keyword aspnetAttribute contained   ClassName ClientTarget CodePage CompilerOptions ContentType Culture
syn keyword aspnetAttribute contained   Debug Description EnableSessionState EnableViewState EnableViewStateMac
syn keyword aspnetAttribute contained   ErrorPage Explicit Inherits Language LCID ResponseEncoding Src
syn keyword aspnetAttribute contained   SmartNavigation Strict Trace TraceMode Transaction UICulture WarningLevel
syn keyword aspnetAttribute contained   Namespace Interface TagPrefix TagName Duration Location
syn keyword aspnetAttribute contained   VaryByCustom VaryByHeader VaryByParam VaryByControl Control

" ASP.NET server side script blocks.
" EXAMPLE: <script runat="server"> ... </script>
" FIXME:   This is a pretty skety region here -- I can't seem to get the end
"          </script> tag to be part of the region... annoying.
syn region aspnetServerScript matchgroup=Special start=+<script[^>]*runat="\=server"\=[^>]*>+ end=+</script>+ contained contains=@aspnetAddCS fold

" ASP standard server controls
" EXAMPLE: <asp:TextBox id="t1" runat="server"/>
" NOTE:    I've set this up to only work if runat="server" is present since I
"          always forget to put that in, and then wonder why things don't
"          work.
syn match aspnetServerControl contained +asp:\w\+\(.*runat="\=server"\=\)\@=+ contains=aspnetServerControlName,aspnetServerControlPunct
syn match aspnetServerControl contained +/asp:\w\++ contains=aspnetServerControlName,aspnetServerControlPunct
syn match aspnetServerControlPunct contained +:+
syn keyword aspnetServerControlName contained Literal PlaceHolder Xml AdRotator Button Calendar CheckBox
syn keyword aspnetServerControlName contained CheckBoxList DataGrid DataList DropDownList HyperLink Image
syn keyword aspnetServerControlName contained ImageButton Label LinkButton ListBox Panel PlaceHolder RadioButton
syn keyword aspnetServerControlName contained RadioButtonList Repeater Table TableCell TableRow TextBox
syn keyword aspnetServerControlArg contained runat id OnSelectedIndexChanged AutoPostBack EnableViewState

" Add these new custom tags to the rest of the HTML markup rules
syn cluster htmlTagNameCluster add=aspnetServerControl
syn cluster htmlArgCluster add=aspnetServerControlArg

"
" Link the highlighting up
"
hi def link aspnetSpecialTagPunct       Delimiter
hi def link aspnetDataBindRegionPunct   Delimiter
hi def link aspnetDirective             Statement
hi def link aspnetAttribute             Type
hi def link aspnetServerControl         PreProc
hi def link aspnetServerControlName     PreProc
hi def link aspnetServerControlPunct    Delimiter
hi def link aspnetServerControlArg      Type

let b:current_syntax = "aspnet"

