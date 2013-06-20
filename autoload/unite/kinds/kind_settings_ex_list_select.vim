let s:save_cpo = &cpo
set cpo&vim

function! s:delete(dict_name, valname_ex, delete_nums) "{{{

	let delete_nums = copy(a:delete_nums)
	call reverse(sort(delete_nums))

	" 番号の取得
	let datas = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default

	" 選択番号の削除
	let nums = get(datas, 'nums', [datas.num])

	" 削除 ( 大きい数字から削除 ) 
	for delete_num in delete_nums
		" 番号の更新
		if exists('datas.items[delete_num]')
			echo delete_num
			unlet datas.items[delete_num]
		endif

		" 削除
		call filter(nums, "v:val != delete_num")
		call map(nums, "v:val - (v:val > delete_num? 1: 0)")
	endfor

	" 選択番号の設定
	if exists('datas.nums')
		let datas.nums = nums
	else
		let datas.num = nums[0]
	endif

	" 設定
	call unite_setting_ex#kind#set(a:dict_name, a:valname_ex, datas)

endfunction
"}}}

function! unite#kinds#kind_settings_ex_list_select#define()
	return s:kind_settings_ex_list_select
endfunction

let s:kind_settings_ex_list_select = { 
			\ 'name'           : 'settings_ex_list_select',
			\ 'default_action' : 'a_toggle',
			\ 'action_table'   : {},
			\ 'parents': ['kind_settings_ex_common'],
			\ }
let s:kind_settings_ex_list_select.action_table.a_toggles = {
			\ 'is_selectable' : 1,
			\ 'description'   : 'select item(s)',
			\ 'is_quit'       : 0,
			\ }
function! s:kind_settings_ex_list_select.action_table.a_toggles.func(candidates) "{{{
	let candidates =  a:candidates

	let dict_name    = candidates[0].action__dict_name
	let valname_ex   = candidates[0].action__valname_ex

	let tmps = unite_setting_ex#dict(dict_name)[valname_ex].__default

	let max  = len(tmps.items)
	let nums = []
	let nums = map(copy(candidates), "v:val.action__num")
	let nums = filter(nums, '0 <= v:val && v:val < max')

	" 新規追加の場合
	if candidates[0].action__new != ''
		call add(tmps.items, candidates[0].action__new)
	else
		call unite#force_quit_session()
	endif

	let tmps.nums = nums
	call unite_setting_ex#kind#set(dict_name, valname_ex, tmps)
	call unite#force_redraw()
endfunction
"}}}

let s:kind_settings_ex_list_select.action_table.a_toggle = {
			\ 'description' : 'select item',
			\ 'is_quit'     : 0,
			\ }
function! s:kind_settings_ex_list_select.action_table.a_toggle.func(candidates) "{{{
	let dict_name    = a:candidates.action__dict_name
	let valname_ex   = a:candidates.action__valname_ex

	let tmps = unite_setting_ex#dict(dict_name)[valname_ex].__default

	let max  = len(tmps.items)
	let num_ = a:candidates.action__num
	let num_ = ( 0 <= num_ && num_ < max ) ? num_ : -1 

	" 新規追加の場合
	if a:candidates.action__new != ''
		call add(tmps.items, a:candidates.action__new)
	else
		call unite#force_quit_session()
	endif

	let tmps.num = num_
	call unite_setting_ex#kind#set(dict_name, valname_ex, tmps)
	call unite#force_redraw()
endfunction
"}}}

let s:kind_settings_ex_list_select.action_table.delete = {
			\ 'is_selectable' : 1,
			\ 'description'   : 'delete (const)',
			\ 'is_quit'        : 0,
			\ }
function! s:kind_settings_ex_list_select.action_table.delete.func(candidates) "{{{

	" init
	let valname_ex = a:candidates[0].action__valname_ex
	let dict_name  = a:candidates[0].action__dict_name

	let candidates = deepcopy( av:candidates ) 
	call filter( candidates, 'v:val.action__const')
	call filter( candidates, 'v:val.action__select')

	let nums = map(copy(a:candidates), 'v:val.action__num')

	" delete
	call s:delete(dict_name, valname_ex, nums)

	call unite#force_redraw()
endfunction
"}}}
"
call unite#define_kind(s:kind_settings_ex_list_select)

let &cpo = s:save_cpo
unlet s:save_cpo
