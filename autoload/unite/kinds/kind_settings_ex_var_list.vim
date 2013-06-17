let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_var_list#define()
	return s:kind_settings_ex_var
endfunction
let s:kind_settings_ex_var = { 
			\ 'name'           : 'kind_settings_ex_var_list',
			\ 'default_action' : 'select',
			\ 'action_table'   : {},
			\ 'parents': ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_var.action_table.select = {
			\ 'description' : 'ê›íËï“èW',
			\ 'is_quit'     : 0,
			\ }"
function! s:kind_settings_ex_var.action_table.select.func(candidate) "{{{
	let valname   = a:candidate.action__valname
	call unite#start_temporary([['settings_var', valname]])
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
