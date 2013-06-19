let s:save_cpo = &cpo
set cpo&vim

" [2013-06-18 00:14]

function! unite#kinds#kind_settings_ex_bool#define()
	return s:kind_settings_ex_bool
endfunction

let s:kind_settings_ex_bool = { 
			\ 'name'           : 'kind_settings_ex_bool',
			\ 'default_action' : 'a_toggle',
			\ 'action_table'   : {},
			\ 'parents'        : ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_bool.action_table.a_toggle = {
			\ 'is_selectable' : 1,
			\ 'description'   : 'ê›íËÇÃêÿë÷',
			\ 'is_quit'       : 0,
			\ }
function! s:kind_settings_ex_bool.action_table.a_toggle.func(candidates)
	for candidate in a:candidates
		call unite_setting_ex#kind#set_next(
					\ candidate.action__dict_name,
					\ candidate.action__valname_ex,
					\ )
	endfor
	call unite#force_redraw()
endfunction 

call unite#define_kind(s:kind_settings_ex_bool)

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif

