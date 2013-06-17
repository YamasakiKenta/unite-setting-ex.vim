let s:save_cpo = &cpo
set cpo&vim

let s:default = 'g:unite_setting_ex_default_data'
function! s:get_dict_name(...)
	return get(a:, 1, '') == '' ? s:default : a:1
endfunction
function! s:get_type(val) "{{{
	let val_type_ = type(a:val)
	if type(0) ==  val_type_
		let type_ = 'bool'
	elseif type([]) == val_type_
		let type_ = 'list'
	elseif type({}) == val_type_
		if type(get(a:val, 'num', [])) == type(0)
			let type_ = 'select'
		elseif type(get(a:val, 'nums', 0)) == type([])
			let type_ = 'list_ex'
		else
			let type_ = 'list' 
		endif
	else
		let type_ = 'var'
	endif
	return type_
endfunction
"}}}
function! s:get_lists(datas) "{{{
	try
		let rtns = []
		let max = len(a:datas.items)
		for num_ in filter(a:datas.nums, 'v:val < max')
			call add(rtns, a:datas.items[num_])
		endfor
		return rtns

	catch
		echo 's:get_lists -> ERROR'
		return []
	endtry
endfunction
"}}}
function! s:add_with_type(dict_name, valname_ex, description, val, type) "{{{
	" ********************************************************************************
	" @param[in]     a:dict_name   : 'unite_pf_data'
	" @param[in]     a:description : ''
	" @param[in]     a:description : { 'num' : 0, 'items' : [1,2,3] }
	" @param[in]     a:type        : 'select'
	" @return       
	" ********************************************************************************

	let dict_name = s:get_dict_name(a:dict_name)

	if exists(dict_name)
		exe 'let tmp_d = '.dict_name
	else
		let tmp_d = {}
	endif

	" 更新
	let tmp_d[a:valname_ex] = get(tmp_d, a:valname_ex, {})
	let tmp_d[a:valname_ex].__type        = a:type
	let tmp_d[a:valname_ex].__description = a:description
	let tmp_d[a:valname_ex].__default     = a:val

	" 一番最初
	let tmp_d.__order = get(tmp_d , '__order', [])

	" 未登録なら
	if match(tmp_d.__order, '^'.a:valname_ex.'$') < 0
		call add(tmp_d.__order, a:valname_ex)
		echo tmp_d.__order
	endif

	" 保存
	exe 'let '.dict_name.' = tmp_d'

	" 変数の更新
	if a:valname_ex =~ '^g:'
		let tmp = unite_setting_ex#data#get(dict_name, a:valname_ex)
		exe 'let '.a:valname_ex.' = tmp'
	endif

endfunction
"}}}

function! unite_setting_ex#data#add(dict_name, valname_ex, description, val) "{{{
	let type_ = s:get_type(a:val)
	return s:add_with_type(a:dict_name, a:valname_ex, a:description, a:val, type_) 
endfunction
"}}}
function! unite_setting_ex#data#get(dict_name, valname_ex) "{{{

	let dict_name = s:get_dict_name(a:dict_name)

	" 値の取得
	exe 'let tmp_d = '.dict_name

	let type_ = tmp_d[a:valname_ex].__type
	let val   = tmp_d[a:valname_ex].__default

	if type_ == 'list_ex' 
		let rtns = s:get_lists(val)
	elseif type_ == 'select'
		let rtns = val.items[val.num]
	elseif type_ == 'bool'
		try
			let rtns = val > 0 ? 1 : 0
		catch
			let rtns = 0
		endtry
	else
		let rtns = val
	endif

	return rtns
endfunction
"}}}
function! unite_setting_ex#data#init(...) "{{{
	" ********************************************************************************
	" @par
	" @param[in]     a:1 dict_name
	" @param[in]     a:2 filename
	" ********************************************************************************

	let dict_name = call('s:get_dict_name', a:000)

	if !exists(dict_name)
		let file_name = get(a:, 2, expand('~/.'.matchstr(dict_name, 'g:\zs.*')))
		echo 'unite_setting_ex#data#init -> init'
		let tmp = {
					\ "__order"  : [],
					\ "__file"   : file_name,
					\ }
		exe 'let '.dict_name.' = tmp'

		call call('unite_setting_ex#data#load', a:000)
	else
	endif

	return dict_name 
endfunction
"}}}
function! unite_setting_ex#data#load(...) "{{{

	let dict_name = call('s:get_dict_name', a:000)

	exe 'let tmp_d = '.dict_name
	let file_ = get(tmp_d, '__file', '')

	
	if !filereadable(file_)
		echo 'unite_setting_ex#data#load -> not find '.file_
		return
	endif

	let load_d = unite_setting_ex#util#load(file_, {})


	let load_d.__file  = file_

	" Add 後、データだけ読み出したい場合の為
	if len(tmp_d.__order)
		let load_d.__order = tmp_d.__order
	endif

	call extend(tmp_d, load_d)

	" ★ ADD の時点でも行うが、ファイルで取得した値を入れる
	"
	" 変数の修正をする
	for valname in filter(copy(tmp_d.__order), 'v:val=~"g:"')
		exe 'let '.valname." = unite_setting_ex#data#get(dict_name, valname)"
	endfor

	return tmp_d
endfunction
"}}}

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
