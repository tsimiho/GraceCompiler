	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:                                ; %entry
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w0, #42
	bl	_writeInteger
Lloh0:
	adrp	x0, l_nl@PAGE
Lloh1:
	add	x0, x0, l_nl@PAGEOFF
	bl	_writeString
	mov	w0, wzr
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
.zerofill __DATA,__bss,l_vars,208,4     ; @vars
	.section	__TEXT,__const
l_nl:                                   ; @nl
	.asciz	"\n"

.subsections_via_symbols
