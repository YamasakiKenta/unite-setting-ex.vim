let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_var#define()
	return s:kind_settings_ex_var
endfunction

let s:kind_settings_ex_var = { 
			\ 'name'           : 'kind_settings_ex_var',
			\ 'default_action' : 'edit',
			\ 'action_table'   : {},
			\ 'parents': ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_var.action_table.edit = {
			\ 'is_quit'     : 0,
			\ }"
function! s:kind_settings_ex_var.action_table.edit.func(candidate) "{{{
	let dict_name  = a:candidate.action__dict_name
	let valname_ex = a:candidate.action__valname_ex
	let tmp        = input("",string(unite_setting_ex#dict(dict_name)[valname_ex].__default))

	if tmp != ""
		exe 'let val = '.tmp
		call unite_setting_ex#kind#set(dict_name, valname_ex, val)
	endif

	call unite#force_redraw()
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
