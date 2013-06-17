let s:save_cpo = &cpo
set cpo&vim

function! s:next_items(num, items) "{{{
	" ********************************************************************************
	" @par           {items} の配列数を超えないように {num} を加算する
	" @param[in]     num   = 0
	" @param[in]     items = [1, 2, 3]
	" @return        num   = 1
	" ********************************************************************************
	let num_ = a:num + 1
	let num_ = num_ < len(a:items) ? num_ : 0
	return num_
endfunction
" }}}

function! unite_setting_ex#kind#set_next(dict_name, valname_ex) "{{{
	let type = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__type

	if type == 'bool'
		let val = unite_setting_ex#data#get(a:dict_name, a:valname_ex) ? 0 : 1
	elseif type == 'select'
		let val = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default
		let val.num = s:next_items(val.num, val.items)
	elseif type == 'list_ex'
		let val = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default
		call map(val.nums, 's:next_items(v:val, val.items)')
	else
		echo 'non supoert....'
		call input("")
	endif

	call unite_setting_ex#kind#set(a:dict_name, a:valname_ex, val )
endfunction
"}}}
function! unite_setting_ex#kind#set(dict_name, valname_ex, val) "{{{

	let tmp_name = a:dict_name.'["'.a:valname_ex.'"]["__default"]'
	if exists(tmp_name)
		let valname = tmp_name
	else
		let valname = a:valname_ex
	endif

	exe 'let '.valname.' = a:val'

	if a:valname_ex =~ '^g:'
		let tmp = unite_setting_ex#data#get(a:dict_name, a:valname_ex)
		exe 'let '.a:valname_ex.' = tmp'
	endif

endfunction
"}}}
"
function! unite_setting_ex#kind#unite_list_select(candidate) "{{{

	let const_ = unite_setting_ex#get_const_flg(
				\ a:candidate.action__dict_name,
				\ a:candidate.action__valname_ex, 
				\ )

	let tmp_d = {
				\ 'dict_name'  : a:candidate.action__dict_name,
				\ 'valname_ex' : a:candidate.action__valname_ex,
				\ 'kind'       : '__default',
				\ 'const_'     : const_,
				\ }

	call unite#start_temporary([['settings_ex_list_select', tmp_d]])
endfunction
"}}}

if exists('s:save_cpo')
	let &cpo = s:save_cpo
	unlet s:save_cpo
else
	set cpo&
endif
