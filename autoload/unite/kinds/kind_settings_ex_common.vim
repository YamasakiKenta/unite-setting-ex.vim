let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_common#define()
	return s:kind_settings_ex_common
endfunction
let s:kind_settings_ex_common = { 
			\ 'name'           : 'kind_settings_ex_common',
			\ 'default_action' : 'yank',
			\ 'action_table'   : {},
			\ }
let s:kind_settings_ex_common.action_table.yank = {
			\ 'description'   : '',
			\ 'is_quit'       : 0,
			\ 'is_selectable' : 1,
			\ }
function! s:kind_settings_ex_common.action_table.yank.func(candidates) "{{{
	let @" = ''
	for candidate in a:candidates
		let dict_name  = candidate.action__dict_name
		let valname_ex = candidate.action__valname_ex

		let data = 'let '.valname_ex.' = '.string(unite_setting_ex#data#get( dict_name, valname_ex))."\n"
		let @" = @" . data

	endfor
	let @* = @"
	echo @"
endfunction
"}}}
"
let s:kind_settings_ex_common.action_table.edit = {
			\ 'description'   : 'edit ( const ) ',
			\ 'is_quit'       : 0,
			\ }
function! s:kind_settings_ex_common.action_table.edit.func(candidate)  "{{{
	let valname    = a:candidate.action__valname

	if exists(valname)
		exe 'let str = string('.valname.')'
	els
		let str = ''
	endif

	let str = input(valname.' : ', str)

	if str !=# ""
		exe 'let '.valname.' = '.str
	endif

	call unite#force_redraw()
endfunction
"}}}

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
