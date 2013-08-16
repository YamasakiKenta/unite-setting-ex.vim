let s:save_cpo = &cpo
set cpo&vim

" [2013-06-18 00:14]

function! unite#kinds#kind_settings_ex_bool#define()
	return s:kind_settings_ex_bool
endfunction

let s:kind_settings_ex_bool = { 
			\ 'name'           : 'kind_settings_ex_bool',
			\ 'default_action' : 'toggle',
			\ 'action_table'   : {},
			\ 'parents'        : ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_bool.action_table.toggle = {
			\ 'description'   : '設定の切替',
			\ 'is_quit'       : 0,
			\ }
function! s:kind_settings_ex_bool.action_table.toggle.func(candidate)
	call unite_setting_ex#kind#set_next(
				\ a:candidate.action__dict_name,
				\ a:candidate.action__valname_ex,
				\ )
	call unite#force_redraw()
endfunction 

call unite#define_kind(s:kind_settings_ex_bool)

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif

