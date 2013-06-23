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

function! unite_setting_ex#source#get_on_off(dict_name, valname_ex) "{{{
	" ********************************************************************************
	" @return [{'str' : '', 'flg' : ''}]
	" ********************************************************************************
	let datas    = copy(unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default)
	let type     = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__type
	let num_flgs = get(datas, 'nums', [])
	let const_flgs = get(datas, 'consts', [])

	let rtns = map(copy(datas.items), "{
				\ 'str'   : ' '.s:get_str(v:val).' ',
				\ 'flg'   : 0,
				\ 'const' : 0,
				\ }")

	let tmp_strs = copy(datas.items)

	if get(const_flgs, 0, 0) < 0
		let nums = range(len(rtns))
	else
		let nums = filter(copy(const_flgs), 'v:val >= 0')
	endif

	for num_ in nums
		let rtns[num_].const = 1

		let rtns[num_].str   = '+'.s:get_str(get(datas.items, num_, '*ERROR*')).'+'
	endfor

	for num_ in filter(copy(num_flgs), 'v:val >= 0')
		let rtns[num_].flg = 1

		let tmp_str = s:get_str(get(datas.items, num_, '*ERROR*'))
		let rtns[num_].str = '<'.tmp_str.'>'
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
