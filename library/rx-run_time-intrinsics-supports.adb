
with Interfaces;
package body Rx.Run_Time.Intrinsics.Supports is
   
   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Unsigned_8 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;
   
   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Unsigned_8 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;
   
   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Unsigned_8 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;
   
   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Unsigned_8 (Interfaces.Rotate_left (U, Count));
   end Rotate_Left;
   
   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Unsigned_8;
      Count : Natural) return Unsigned_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Unsigned_8 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Unsigned_16 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Unsigned_16 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Unsigned_16 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Unsigned_16 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Unsigned_16;
      Count : Natural) return Unsigned_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Unsigned_16 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Unsigned_32 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Unsigned_32 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Unsigned_32 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Unsigned_32 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Unsigned_32;
      Count : Natural) return Unsigned_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Unsigned_32 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Unsigned_64 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Unsigned_64 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Unsigned_64 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Unsigned_64 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Unsigned_64;
      Count : Natural) return Unsigned_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Unsigned_64 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;
   
   
   
   
   -- Signed Versions --
   ---------------------
   
   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Integer_8;
      Count : Natural) return Integer_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Integer_8 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;
   
   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Integer_8;
      Count : Natural) return Integer_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Integer_8 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;
   
   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Integer_8;
      Count : Natural) return Integer_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Integer_8 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;
   
   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Integer_8;
      Count : Natural) return Integer_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Integer_8 (Interfaces.Rotate_left (U, Count));
   end Rotate_Left;
   
   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Integer_8;
      Count : Natural) return Integer_8 is
      
      U : Interfaces.Unsigned_8 := Interfaces.Unsigned_8 (Value);
   begin
      return Integer_8 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Integer_16;
      Count : Natural) return Integer_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Integer_16 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Integer_16;
      Count : Natural) return Integer_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Integer_16 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Integer_16;
      Count : Natural) return Integer_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Integer_16 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Integer_16;
      Count : Natural) return Integer_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Integer_16 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Integer_16;
      Count : Natural) return Integer_16 is
      
      U : Interfaces.Unsigned_16 := Interfaces.Unsigned_16 (Value);
   begin
      return Integer_16 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Integer_32;
      Count : Natural) return Integer_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Integer_32 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Integer_32;
      Count : Natural) return Integer_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Integer_32 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Integer_32;
      Count : Natural) return Integer_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Integer_32 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Integer_32;
      Count : Natural) return Integer_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Integer_32 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Integer_32;
      Count : Natural) return Integer_32 is
      
      U : Interfaces.Unsigned_32 := Interfaces.Unsigned_32 (Value);
   begin
      return Integer_32 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;

   ----------------
   -- Shift_Left --
   ----------------
   
   function Shift_Left
     (Value : Integer_64;
      Count : Natural) return Integer_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Integer_64 (Interfaces.Shift_Left (U, Count));
   end Shift_Left;

   -----------------
   -- Shift_Right --
   -----------------
   
   function Shift_Right
     (Value : Integer_64;
      Count : Natural) return Integer_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Integer_64 (Interfaces.Shift_Right (U, Count));
   end Shift_Right;

   ----------------------------
   -- Shift_Right_Arithmetic --
   ----------------------------
   
   function Shift_Right_Arithmetic
     (Value : Integer_64;
      Count : Natural) return Integer_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Integer_64 (Interfaces.Shift_Right_Arithmetic (U, Count));
   end Shift_Right_Arithmetic;

   -----------------
   -- Rotate_Left --
   -----------------
   
   function Rotate_Left
     (Value : Integer_64;
      Count : Natural) return Integer_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Integer_64 (Interfaces.Rotate_Left (U, Count));
   end Rotate_Left;

   ------------------
   -- Rotate_Right --
   ------------------
   
   function Rotate_Right
     (Value : Integer_64;
      Count : Natural) return Integer_64 is
      
      U : Interfaces.Unsigned_64 := Interfaces.Unsigned_64 (Value);
   begin
      return Integer_64 (Interfaces.Rotate_Right (U, Count));
   end Rotate_Right;
   
   
   -- Logical word operations --
   -----------------------------
   
   ----------
   -- "or" --
   ----------
   
   function "or"  (Left, Right : Integer_8) return Integer_8 is
   begin
      return Integer_8 (Unsigned_8 (Left) or Unsigned_8 (Right));
   end "or";
   
   -----------
   -- "and" --
   -----------
   
   function "and" (Left, Right : Integer_8) return Integer_8 is
   begin
      return Integer_8 (Unsigned_8 (Left) and Unsigned_8 (Right));
   end "and";
   
   -----------
   -- "xor" --
   -----------
   
   function "xor" (Left, Right : Integer_8) return Integer_8 is
   begin
      return Integer_8 (Unsigned_8 (Left) xor Unsigned_8 (Right));
   end "xor";
   
   -----------
   -- "not" --
   -----------
   
   function "not" (Left : Integer_8) return Integer_8 is
   begin
      return Integer_8 (not Unsigned_8 (Left));
   end "not";
   
   ----------
   -- "or" --
   ----------
   
   function "or"  (Left, Right : Integer_16) return Integer_16 is
   begin
      return Integer_16 (Unsigned_16 (Left) or Unsigned_16 (Right));
   end "or";
   
   -----------
   -- "and" --
   -----------
   
   function "and" (Left, Right : Integer_16) return Integer_16 is
   begin
      return Integer_16 (Unsigned_16 (Left) and Unsigned_16 (Right));
   end "and";
   
   -----------
   -- "xor" --
   -----------
   
   function "xor" (Left, Right : Integer_16) return Integer_16 is
   begin
      return Integer_16 (Unsigned_16 (Left) xor Unsigned_16 (Right));
   end "xor";
   
   -----------
   -- "not" --
   -----------
   
   function "not" (Left : Integer_16) return Integer_16 is
   begin
      return Integer_16 (not Unsigned_16 (Left));
   end "not";
   
   ----------
   -- "or" --
   ----------
   
   function "or"  (Left, Right : Integer_32) return Integer_32 is
   begin
      return Integer_32 (Unsigned_32 (Left) or Unsigned_32 (Right));
   end "or";
   
   -----------
   -- "and" --
   -----------
   
   function "and" (Left, Right : Integer_32) return Integer_32 is
   begin
      return Integer_32 (Unsigned_32 (Left) and Unsigned_32 (Right));
   end "and";
   
   -----------
   -- "xor" --
   -----------
   
   function "xor" (Left, Right : Integer_32) return Integer_32 is
   begin
      return Integer_32 (Unsigned_32 (Left) xor Unsigned_32 (Right));
   end "xor";
   
   -----------
   -- "not" --
   -----------
   
   function "not" (Left : Integer_32) return Integer_32 is
   begin
      return Integer_32 (not Unsigned_32 (Left));
   end "not";
   
   ----------
   -- "or" --
   ----------
   
   function "or"  (Left, Right : Integer_64) return Integer_64 is
   begin
      return Integer_64 (Unsigned_64 (Left) or Unsigned_64 (Right));
   end "or";
   
   -----------
   -- "and" --
   -----------
   
   function "and" (Left, Right : Integer_64) return Integer_64 is
   begin
      return Integer_64 (Unsigned_64 (Left) and Unsigned_64 (Right));
   end "and";
   
   -----------
   -- "xor" --
   -----------
   
   function "xor" (Left, Right : Integer_64) return Integer_64 is
   begin
      return Integer_64 (Unsigned_64 (Left) xor Unsigned_64 (Right));
   end "xor";
   
   -----------
   -- "not" --
   -----------
   
   function "not" (Left : Integer_64) return Integer_64 is
   begin
      return Integer_64 (not Unsigned_64 (Left));
   end "not";
   
end Rx.Run_Time.Intrinsics.Supports;
