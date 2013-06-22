let s:save_cpo = &cpo
set cpo&vim

function! unite_setting_ex#sub_setting_syntax(args, context) 
	syntax match uniteSource__settings_const / +.\{-}+\>/ containedin=uniteSource__settings contained
	syntax match uniteSource__settings_choose / <.\{-}>/ containedin=uniteSource__settings contained
	syntax match uniteSource__settings_choose / |.\{-}>/ containedin=uniteSource__settings contained
	highlight default link uniteSource__settings_choose Type 
	highlight default link uniteSource__settings_const Underlined
endfunction

function! unite_setting_ex#version()
	return 0.1
endfunction

function! unite_setting_ex#dict(dict_name) 
	exe 'return '.a:dict_name
endfunction

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
