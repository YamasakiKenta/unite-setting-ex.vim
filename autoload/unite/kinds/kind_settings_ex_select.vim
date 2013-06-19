let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_select#define()
	return s:kind_settings_ex_select
endfunction
let s:kind_settings_ex_select = { 
			\ 'name'           : 'kind_settings_ex_select',
			\ 'default_action' : 'a_toggle',
			\ 'action_table'   : {},
			\ 'parents': ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_select.action_table.a_toggle = {
			\ 'description' : '‘I‘ð',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_select.action_table.a_toggle.func(candidate) "{{{
	let dict_name  = a:candidate.action__dict_name
	let valname_ex = a:candidate.action__valname_ex

	call unite_setting_ex#kind#set_next(dict_name, valname_ex)
	call unite#force_redraw()
endfunction
"}}}
let s:kind_settings_ex_select.action_table.edit = {
			\ 'description' : 'edit',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_select.action_table.edit.func(...) 
	return call('unite_setting_ex#kind#unite_list_select', a:000)
endfunction

call unite#define_kind(s:kind_settings_ex_select)

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
