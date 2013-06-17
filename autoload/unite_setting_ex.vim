let s:save_cpo = &cpo
set cpo&vim

function! unite_setting_ex#sub_setting_syntax(args, context) 
	syntax match uniteSource__settings_choose /<.\{-}>/ containedin=uniteSource__settings contained
	syntax match uniteSource__settings_const /[.\{-}]/ containedin=uniteSource__settings contained
	highlight default link uniteSource__settings_choose Type 
	highlight default link uniteSource__settings_const Underlined  
endfunction

function! unite_setting_ex#version()
	return 0.1
endfunction

function! unite_setting_ex#dict(dict_name) 
	exe 'return '.a:dict_name
endfunction

function! unite_setting_ex#get_const_flg(dict_name, valname_ex) "{{{
	let datas = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default

	let flg = 0
	if exists('datas.consts')
		if len(datas.consts)
			let flg = 1
		endif
	endif

	return flg
endfunction
"}}}

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
