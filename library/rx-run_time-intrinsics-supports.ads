
package Rx.Run_Time.Intrinsics.Supports is
   
   type Integer_8  is range -2 **  7 .. 2 **  7 - 1;
   for Integer_8'Size use  8;

   type Integer_16 is range -2 ** 15 .. 2 ** 15 - 1;
   for Integer_16'Size use 16;

   type Integer_32 is range -2 ** 31 .. 2 ** 31 - 1;
   for Integer_32'Size use 32;

   type Integer_64 is range -2 ** 63 .. 2 ** 63 - 1;
   for Integer_64'Size use 64;

   type Unsigned_8  is mod 2 **  8;
   for Unsigned_8'Size use  8;

   type Unsigned_16 is mod 2 ** 16;
   for Unsigned_16'Size use 16;

   type Unsigned_32 is mod 2 ** 32;
   for Unsigned_32'Size use 32;

   type Unsigned_64 is mod 2 ** 64;
   for Unsigned_64'Size use 64;
   
   -- Unsigned version --
   ----------------------
   
   function Shift_Left
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8;

   function Shift_Right
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8;

   function Shift_Right_Arithmetic
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8;

   function Rotate_Left
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8;

   function Rotate_Right
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8;

   function Shift_Left
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16;

   function Shift_Right
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16;

   function Shift_Right_Arithmetic
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16;

   function Rotate_Left
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16;

   function Rotate_Right
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16;

   function Shift_Left
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32;

   function Shift_Right
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32;

   function Shift_Right_Arithmetic
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32;

   function Rotate_Left
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32;

   function Rotate_Right
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32;

   function Shift_Left
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64;

   function Shift_Right
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64;

   function Shift_Right_Arithmetic
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64;

   function Rotate_Left
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64;

   function Rotate_Right
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64;
   
   -- Signed Version --
   --------------------
   
   function Shift_Left
     (Value : Integer_8;
      Count : Natural) return Integer_8;

   function Shift_Right
     (Value : Integer_8;
      Count : Natural) return Integer_8;

   function Shift_Right_Arithmetic
     (Value : Integer_8;
      Count : Natural) return Integer_8;

   function Rotate_Left
     (Value : Integer_8;
      Count : Natural) return Integer_8;

   function Rotate_Right
     (Value : Integer_8;
      Count : Natural) return Integer_8;

   function Shift_Left
     (Value : Integer_16;
      Count : Natural) return Integer_16;

   function Shift_Right
     (Value : Integer_16;
      Count : Natural) return Integer_16;

   function Shift_Right_Arithmetic
     (Value : Integer_16;
      Count : Natural) return Integer_16;

   function Rotate_Left
     (Value : Integer_16;
      Count : Natural) return Integer_16;

   function Rotate_Right
     (Value : Integer_16;
      Count : Natural) return Integer_16;

   function Shift_Left
     (Value : Integer_32;
      Count : Natural) return Integer_32;

   function Shift_Right
     (Value : Integer_32;
      Count : Natural) return Integer_32;

   function Shift_Right_Arithmetic
     (Value : Integer_32;
      Count : Natural) return Integer_32;

   function Rotate_Left
     (Value : Integer_32;
      Count : Natural) return Integer_32;

   function Rotate_Right
     (Value : Integer_32;
      Count : Natural) return Integer_32;

   function Shift_Left
     (Value : Integer_64;
      Count : Natural) return Integer_64;

   function Shift_Right
     (Value : Integer_64;
      Count : Natural) return Integer_64;

   function Shift_Right_Arithmetic
     (Value : Integer_64;
      Count : Natural) return Integer_64;

   function Rotate_Left
     (Value : Integer_64;
      Count : Natural) return Integer_64;

   function Rotate_Right
     (Value : Integer_64;
      Count : Natural) return Integer_64;
   
   -- Logical word operations --
   -----------------------------
   
   function "or"  (Left, Right : Integer_8) return Integer_8;
   function "and" (Left, Right : Integer_8) return Integer_8;
   function "xor" (Left, Right : Integer_8) return Integer_8;
   function "not" (Left        : Integer_8) return Integer_8;
   
   function "or"  (Left, Right : Integer_16) return Integer_16;
   function "and" (Left, Right : Integer_16) return Integer_16;
   function "xor" (Left, Right : Integer_16) return Integer_16;
   function "not" (Left        : Integer_16) return Integer_16;
   
   function "or"  (Left, Right : Integer_32) return Integer_32;
   function "and" (Left, Right : Integer_32) return Integer_32;
   function "xor" (Left, Right : Integer_32) return Integer_32;
   function "not" (Left        : Integer_32) return Integer_32;
   
   function "or"  (Left, Right : Integer_64) return Integer_64;
   function "and" (Left, Right : Integer_64) return Integer_64;
   function "xor" (Left, Right : Integer_64) return Integer_64;
   function "not" (Left        : Integer_64) return Integer_64;
   
end Rx.Run_Time.Intrinsics.Supports;
