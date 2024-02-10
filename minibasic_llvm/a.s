	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:                                ; %entry
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	.cfi_def_cfa_offset 48
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
Lloh0:
	adrp	x19, l_nl@PAGE
	adrp	x20, l_vars@PAGE+184
	mov	w21, #42
Lloh1:
	add	x19, x19, l_nl@PAGEOFF
	str	xzr, [x20, l_vars@PAGEOFF+184]
	subs	x21, x21, #1                    ; =1
	b.lt	LBB0_2
LBB0_1:                                 ; %body
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x20, l_vars@PAGEOFF+184]
	add	x0, x8, #1                      ; =1
	str	x0, [x20, l_vars@PAGEOFF+184]
	bl	_writeInteger
	mov	x0, x19
	bl	_writeString
	subs	x21, x21, #1                    ; =1
	b.ge	LBB0_1
LBB0_2:                                 ; %after
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	mov	w0, wzr
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
.zerofill __DATA,__bss,l_vars,208,4     ; @vars
	.section	__TEXT,__const
l_nl:                                   ; @nl
	.asciz	"\n"

.subsections_via_symbols
