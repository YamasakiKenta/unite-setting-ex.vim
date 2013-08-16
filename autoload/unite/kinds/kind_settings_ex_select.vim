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
			\ 'description' : '選択',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_select.action_table.a_toggle.func(candidate) "{{{
	call unite_setting_ex#kind#set_next(
				\ a:candidate.action__dict_name,
				\ a:candidate.action__valname_ex,
				\ )
	call unite#force_redraw()
endfunction
"}}}
let s:kind_settings_ex_select.action_table.edit = {
			\ 'description' : 'edit',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_select.action_table.edit.func(candidate) 
	let tmp_d = {
				\ 'dict_name'  : a:candidate.action__dict_name,
				\ 'valname_ex' : a:candidate.action__valname_ex,
				\ }

	call unite#start_temporary([['settings_ex_list_select', tmp_d]])
endfunction
"}}}

call unite#define_kind(s:kind_settings_ex_select)

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
