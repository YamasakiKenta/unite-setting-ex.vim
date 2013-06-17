let s:save_cpo = &cpo
set cpo&vim

function! s:conv(str)
	return iconv(a:str, "utf8", "sjis")
endfunction

function! s:printf(...)
	return iconv(call("printf", map(copy(a:000), 'iconv(v:val, &enc, "sjis")')), "sjis", &enc)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
