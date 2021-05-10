------------------------------------------------------------------------------
--                                                                          --
--                         REFLEX COMPILER COMPONENTS                       --
--                                                                          --
--          Copyright (C) 1992-2011, Free Software Foundation, Inc.         --
--                                                                          --
-- Reflex is free software; you can redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware Foundation; either version 3, or (at your option) any later version --
-- Reflex is distributed in the hope that it will be useful, but WITH-      --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License distributed with Reflex; see file COPYING3. If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- Reflex is originally developed  by the Artics team at Grenoble (France). --
--                                                                          --
------------------------------------------------------------------------------

package Rxintr.Maths is
   
   function Sqrt (X : Float) return Float;
   pragma Export (C, Sqrt, "Rxintr_Maths_Sqrt");
   
   function Logn (X : Float) return Float;
   pragma Export (C, Logn, "Rxintr_Maths_Logn");
   
   function Log (X, Base : Float) return Float;
   pragma Export (C, Log, "Rxintr_Maths_log");
   
   function Exp (X : Float) return Float;
   pragma Export (C, Exp, "Rxintr_Maths_Exp");
   
   function Power (Left, Right : Float) return Float;
   pragma Export (C, Power, "Rxintr_Maths_Power");
   
   function Sin (X : Float) return Float;
   pragma Export (C, Sin, "Rxintr_Maths_Sin");
   
   function Sin_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Sin_Cycle, "Rxintr_Maths_Sin_Cycle");
   
   function Cos (X : Float) return Float;
   pragma Export (C, Cos, "Rxintr_Maths_Cos");
     
   function Cos_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Cos_Cycle, "Rxintr_Maths_Cos_Cycle");
   
   function Tan (X : Float) return Float;
   pragma Export (C, Tan, "Rxintr_Maths_Tan");
   
   function Tan_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Tan_Cycle, "Rxintr_Maths_Tan_Cycle");

   function Cot (X : Float) return Float;
   pragma Export (C, Cot, "Rxintr_Maths_Cot");

   function Cot_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Cot_Cycle, "Rxintr_Maths_Cot_Cycle");

   function Arcsin (X : Float) return Float;
   pragma Export (C, Arcsin, "Rxintr_Maths_Arcsin");

   function Arcsin_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Arcsin_Cycle, "Rxintr_Maths_Arcsin_Cycle");

   function Arccos (X : Float) return Float;
   pragma Export (C, Arccos,"Rxintr_Maths_Arccos");

   function Arccos_Cycle (X, Cycle : Float) return Float;
   pragma Export (C, Arccos_Cycle, "Rxintr_Maths_Arccos_Cycle");

   function Arctan
     (Y : Float;
      X : Float) return Float;
   pragma Export (C, Arctan, "Rxintr_Maths_Arctan");

   function Arctan_Cycle
     (Y     : Float;
      X     : Float;
      Cycle : Float) return Float;
   pragma Export (C, Arctan_Cycle, "Rxintr_Maths_Arctan_Cycle");

   function Arccot
     (X   : Float;
      Y   : Float) return Float;
   pragma Export (C, Arccot, "Rxintr_Maths_Arccot");

   function Arccot_Cycle
     (X     : Float;
      Y     : Float;
      Cycle : Float) return Float;
   pragma Export (C, Arccot_Cycle, "Rxintr_Maths_Arccot_Cycle");

   function Sinh (X : Float) return Float;
   pragma Export (C, Sinh, "Rxintr_Maths_Sinh");

   function Cosh(X : Float) return Float;
   pragma Export (C, Cosh, "Rxintr_Maths_Cosh");

   function Tanh (X : Float) return Float;
   pragma Export (C, Tanh, "Rxintr_Maths_Tanh");

   function Coth (X : Float) return Float;
   pragma Export (C, Coth, "Rxintr_Maths_Coth");
     
   function Arcsinh (X : Float) return Float;
   pragma Export (C, Arcsinh, "Rxintr_Maths_Arcsinh");

   function Arccosh (X : Float) return Float;
   pragma Export (C, Arccosh, "Rxintr_Maths_Arccosh");

   function Arctanh (X : Float) return Float;
   pragma Export (C, Arctanh, "Rxintr_Maths_Arctanh");

   function Arccoth (X : Float) return Float;
   pragma Export (C, Arccoth, "Rxintr_Maths_Arccoth");
   
end Rxintr.Maths;
