let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_common#define()
	return s:kind_settings_ex_common
endfunction
let s:kind_settings_ex_common = { 
			\ 'name'           : 'kind_settings_ex_common',
			\ 'default_action' : 'a_toggle',
			\ 'action_table'   : {},
			\ }
			"\ 'parents': ['kind_settings_common'],
			"\ 'parents': ['kind_settings_common'],
let s:kind_settings_ex_common.action_table.yank = {
			\ 'description'   : 'yank',
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

let &cpo = s:save_cpo
unlet s:save_cpo
