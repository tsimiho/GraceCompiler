type typ = TYPE_none       
         | TYPE_int        
         | TYPE_char
         | TYPE_array of   
             typ *         
             int           

val sizeOfType : typ -> int
val equalType : typ -> typ -> bool
