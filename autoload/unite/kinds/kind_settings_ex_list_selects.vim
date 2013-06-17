let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#kind_settings_ex_list_selects#define()
	return s:kind_settings_ex_list_selects
endfunction
let s:kind_settings_ex_list_selects = { 
			\ 'name'           : 'settings_ex_list_selects',
			\ 'default_action' : 'a_toggles',
			\ 'parents': ['settings_ex_list_select'],
			\ }

let &cpo = s:save_cpo
unlet s:save_cpo
