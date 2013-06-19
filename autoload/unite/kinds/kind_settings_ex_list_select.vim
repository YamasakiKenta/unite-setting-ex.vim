let s:save_cpo = &cpo
set cpo&vim

function! s:delete(dict_name, valname_ex, delete_nums) "{{{

	" ���ёւ�
	let delete_nums = copy(a:delete_nums)
	call sort(delete_nums, 'unite_setting_ex2#sort_lager')

	" �ԍ��̎擾
	let datas = unite_setting_ex#dict(a:dict_name)[a:valname_ex].__default

	" �I��ԍ��̍폜
	let nums = get(datas, 'nums')

	" �폜 ( �傫����������폜 ) 
	for delete_num in delete_nums
		" �ԍ��̍X�V
		if exists('datas.items[delete_num]')
			unlet datas.items[delete_num]
		endif

		" �폜
		call filter(nums, "v:val != delete_num")
		call map(nums, "v:val - (v:val > delete_num? 1: 0)")
	endfor

	" �I��ԍ��̐ݒ�
	let datas.nums = nums

	" �ݒ�
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
			\ 'description' : '�ݒ�̐ؑ� ( �����I���\ )',
			\ 'is_quit'        : 0,
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

	" �V�K�ǉ��̏ꍇ
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
			\ 'description' : '�ݒ�̐ؑ�',
			\ 'is_quit'        : 0,
			\ }
function! s:kind_settings_ex_list_select.action_table.a_toggle.func(candidates) "{{{
	let dict_name    = a:candidates.action__dict_name
	let valname_ex   = a:candidates.action__valname_ex

	let tmps = unite_setting_ex#dict(dict_name)[valname_ex].__default

	let max  = len(tmps.items)
	let num_ = a:candidates.action__num
	let num_ = ( 0 <= num_ && num_ < max ) ? num_ : -1 

	" �V�K�ǉ��̏ꍇ
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
			\ 'description'   : 'delete ( kind_settings_ex_list_select.vim ) (const)',
			\ 'is_quit'        : 0,
			\ }
function! s:kind_settings_ex_list_select.action_table.delete.func(candidates) "{{{

	" ������
	let valname_ex = a:candidates[0].action__valname_ex
	let dict_name  = a:candidates[0].action__dict_name
	let const_flg  = a:candidates[0].action__const_flg  

	if const_flg == 1
		unite#print_message("con't edit")
	else

		let nums       = map(copy(a:candidates), 'v:val.action__num')

		" �폜����
		call s:delete(dict_name, valname_ex, nums)

		call unite#force_redraw()
	endif
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
