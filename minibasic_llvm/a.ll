; ModuleID = 'minibasic program'
source_filename = "minibasic program"

@vars = private global [26 x i64] zeroinitializer, align 16
@nl = private constant [2 x i8] c"\0A\00", align 1

declare void @writeInteger(i64)

declare void @writeString(i8*)

define i32 @main() {
entry:
  call void @writeInteger(i64 42)
  call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @nl, i64 0, i64 0))
  ret i32 0
}
