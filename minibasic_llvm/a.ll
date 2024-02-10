; ModuleID = 'minibasic program'
source_filename = "minibasic program"

@vars = private global [26 x i64] zeroinitializer, align 16
@nl = private constant [2 x i8] c"\0A\00", align 1

declare void @writeInteger(i64)

declare void @writeString(i8*)

define i32 @main() {
entry:
  store i64 0, i64* getelementptr inbounds ([26 x i64], [26 x i64]* @vars, i64 0, i64 23), align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %iter = phi i64 [ 42, %entry ], [ %remaining, %body ]
  %loop_cond = icmp sgt i64 %iter, 0
  br i1 %loop_cond, label %body, label %after

body:                                             ; preds = %loop
  %remaining = add i64 %iter, -1
  %x = load i64, i64* getelementptr inbounds ([26 x i64], [26 x i64]* @vars, i64 0, i64 23), align 8
  %addtmp = add i64 %x, 1
  store i64 %addtmp, i64* getelementptr inbounds ([26 x i64], [26 x i64]* @vars, i64 0, i64 23), align 8
  call void @writeInteger(i64 %addtmp)
  call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @nl, i64 0, i64 0))
  br label %loop

after:                                            ; preds = %loop
  ret i32 0
}
