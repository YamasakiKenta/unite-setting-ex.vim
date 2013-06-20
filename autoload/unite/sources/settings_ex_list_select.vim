let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#settings_ex_list_select#define()
	return s:settings_ex_list_select
endfunction
let s:settings_ex_list_select = {
			\ 'name'        : 'settings_ex_list_select',
			\ 'description' : '複数選択',
			\ 'syntax'      : 'uniteSource__settings',
			\ 'hooks'       : {},
			\ }
function! s:settings_ex_list_select.hooks.on_syntax(...)
	return call('unite_setting_ex#sub_setting_syntax', a:000)
endfunction
function! s:settings_ex_list_select.hooks.on_init(args, context) "{{{
	if len(a:args) > 0
		let a:context.source__dict_name    = a:args[0].dict_name
		let a:context.source__valname_ex   = a:args[0].valname_ex
	endif
endfunction
"}}}
function! s:settings_ex_list_select.gather_candidates(args, context) "{{{

	let dict_name  = a:context.source__dict_name
	let valname_ex = a:context.source__valname_ex

	let datas = unite_setting_ex#source#get_strs_on_off_new(dict_name, valname_ex)

	let type = unite_setting_ex#dict(dict_name)[valname_ex].__type

	if type == 'select' 
		" select
		let num_ = 0
		let unite_kind = 'settings_ex_list_select'
	else
		" list
		" 非選択用の項目
		let num_ = -1
		let unite_kind = 'settings_ex_list_selects'
		call insert(datas, {
					\ 'str' : '+NULL+',
					\ 'flg' : 0,
					\ 'const' : 1,
					\ })
	endif

	let rtns = []
	for data in datas
		" 変化するのは、work action__num, action__valname
		let rtns += [{
					\ 'word'               : num_.' - '.data.str,
					\ 'kind'               : unite_kind,
					\ 'action__dict_name'  : dict_name,
					\ 'action__valname_ex' : valname_ex,
					\ 'action__const'      : data.const,
					\ 'action__select'     : data.flg,
					\ 'action__valname'    : dict_name."['".valname_ex."']['__default']['items']['".num_."']",
					\ 'action__num'        : num_,
					\ 'action__new'        : '',
					\ }]
		let num_ += 1
	endfor	

	return rtns

endfunction
"}}}
function! s:settings_ex_list_select.change_candidates(args, context) "{{{

	let new_       = a:context.input
	let dict_name  = a:context.source__dict_name
	let valname_ex = a:context.source__valname_ex

	let rtns = []
	if new_ != ''
		let rtns = [{
					\ 'word' : '[add] '.new_,
					\ 'kind' : 'settings_ex_list_select',
					\ 'action__new'       : new_,
					\ 'action__dict_name' : dict_name,
					\ 'action__valname_ex': valname_ex,
					\ 'action__num'       : 1,
					\ }]
	endif

	return rtns

endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
