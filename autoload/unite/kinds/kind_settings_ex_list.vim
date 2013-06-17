let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_list#define()
	return s:kind_settings_ex_list
endfunction

let s:kind_settings_ex_list = { 
			\ 'name'           : 'kind_settings_ex_list',
			\ 'default_action' : 'a_toggle',
			\ 'action_table'   : {},
			\ 'parents': ['kind_settings_ex_common', 'kind_settings_common'],
			\ }
" action
let s:kind_settings_ex_list.action_table.a_toggle = {
			\ 'description' : 'ëIë',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_list.action_table.a_toggle.func(...)
	return call('unite_setting_ex#kind#unite_list_select', a:000)
endfunction

let s:kind_settings_ex_list.action_table.edit = {
			\ 'description' : 'ê›íËï“èW',
			\ 'is_quit'     : 0,
			\ }"
function! s:kind_settings_ex_list.action_table.edit.func(candidate) "{{{
	let dict_name    = a:candidate.action__dict_name
	let valname_ex   = a:candidate.action__valname_ex

	let const_flg = get(a:candidate, 'action__const_flg', 0)

	if const_flg == 1
		echo "con't edit type"
		return
	endif

	let tmp = input("",string(unite_setting_ex#dict(dict_name)[valname_ex].__default))

	if tmp != ""
		exe 'let val = '.tmp
		call unite_setting_ex#kind#set(dict_name, valname_ex, val)
	endif

	call unite#force_redraw()
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
