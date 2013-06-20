let s:save_cpo = &cpo
set cpo&vim

function! s:get_str(val) "{{{
	let type_ = type(a:val)
	if type_ == type(0) || type_ == type('')
		let str = a:val
	else
		let str = string(a:val)
	endif
	return str
endfunction
"}}}
function! s:get_num_flgs(datas) "{{{
	if exists('a:datas.nums')
		let num_flgs  = a:datas.nums
	elseif exists('a:datas.num')
		let num_flgs  = [a:datas.num]
	else
		let num_flgs = []
	endif
	return num_flgs
endfunction
"}}}
function! s:get_const_flgs(datas) "{{{
	if exists('a:datas.consts')
		let num_flgs  = a:datas.consts
	else
		let num_flgs = []
	endif
	return num_flgs
endfunction
"}}}

function! unite_setting_ex#source#get_strs_on_off_new(dict_name, valname_ex) "{{{
	" ********************************************************************************
	" @return [{'str' : '', 'flg' : ''}]
	" ********************************************************************************
	let datas    = copy(unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default)
	let type     = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__type
	let num_flgs = s:get_num_flgs(datas)
	let const_flgs = s:get_const_flgs(datas)

	let rtns = map(copy(datas.items), "{
				\ 'str'   : ' '.s:get_str(v:val).' ',
				\ 'flg'   : 0,
				\ 'const' : 0,
				\ }")

	let tmp_strs = copy(datas.items)

	for num_ in filter(copy(const_flgs), 'v:val >= 0')
		let rtns[num_].str   = '+'.s:get_str(get(datas.items, num_, '*ERROR*')).'+'
		let rtns[num_].flg   = 0
		let rtns[num_].const = 1
	endfor

	for num_ in filter(copy(num_flgs), 'v:val >= 0')
		let tmp_str = s:get_str(get(datas.items, num_, '*ERROR*'))
		if rtns[num_].const == 1
			let rtns[num_].str = '*'.tmp_str.'*'
		else
			if type == 'select'
				let rtns[num_].str = '<'.tmp_str.'>'
			else
				let rtns[num_].str = '('.tmp_str.')'
			endif
		endif
		let rtns[num_].flg = 1
	endfor

	return rtns
endfunction
"}}}

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
