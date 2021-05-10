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

with Ada.Numerics.Elementary_Functions;

package body Rxintr.Maths is
   
   package Maths_Functions renames Ada.Numerics.Elementary_Functions;
   
   ----------
   -- Sqrt --
   ----------
   
   function Sqrt (X : Float) return Float is
   begin
     return Maths_Functions.Sqrt (X);
   end Sqrt;

   ----------
   -- Logn --
   ----------
   
   function Logn (X : Float) return Float is
   begin
      return Maths_Functions.Log (X);
   end Logn;
   
   ---------
   -- Log --
   ---------
   
   function Log (X, Base : Float) return Float is
   begin
      return Maths_Functions.Log (X, Base);
   end Log;
   
   ---------
   -- Exp --
   ---------
   
   function Exp (X : Float) return Float is
   begin
      return Maths_Functions.Exp (X);
   end Exp;
   
   -----------
   -- Power --
   -----------
   
   function Power (Left, Right : Float) return Float is
   begin
      return Maths_Functions."**" (Left, Right);
   end Power;
   
   ---------
   -- Sin --
   ---------
   
   function Sin (X : Float) return Float is
   begin
      return Maths_Functions.Sin (X);
   end Sin;
   
   ---------------
   -- Sin_Cycle --
   ---------------
   
   function Sin_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Sin (X, Cycle);
   end Sin_Cycle;
   
   ---------
   -- Cos --
   ---------
   
   function Cos (X : Float) return Float is
   begin
      return Maths_Functions.Cos (X);
   end Cos;
   
   ---------------
   -- Cos_Cycle --
   ---------------
   
   function Cos_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Cos (X, Cycle);
   end Cos_Cycle;
   
   ---------
   -- Tan --
   ---------
   
   function Tan (X : Float) return Float is
   begin
      return Maths_Functions.Tan (X);
   end Tan;
   
   ---------------
   -- Tan_Cycle --
   ---------------
   
   function Tan_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Tan (X, Cycle);
   end Tan_Cycle;
   
   ---------
   -- Cot --
   ---------
   
   function Cot (X : Float) return Float is
   begin
      return Maths_Functions.Cot (X);
   end Cot;
   
   ---------------
   -- Cot_Cycle --
   ---------------
   
   function Cot_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Cot (X, Cycle);
   end Cot_Cycle;
   
   ------------
   -- Arcsin --
   ------------
   
   function Arcsin (X : Float) return Float is
   begin
      return Maths_Functions.Arcsin (X);
   end Arcsin;
   
   ------------------
   -- Arcsin_Cycle --
   ------------------
   
   function Arcsin_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Arcsin (X, Cycle);
   end Arcsin_Cycle;
   
   ------------
   -- Arccos --
   ------------
   
   function Arccos (X : Float) return Float is
   begin
      return Maths_Functions.Arccos (X);
   end Arccos;
   
   ------------------
   -- Arccos_Cycle --
   ------------------
   
   function Arccos_Cycle (X, Cycle : Float) return Float is
   begin
      return Maths_Functions.Arccos (X, Cycle);
   end Arccos_Cycle;
   
   ------------
   -- Arctan --
   ------------
   
   function Arctan
     (Y : Float;
      X : Float) return Float is
   begin
      return Maths_Functions.Arctan (Y, X);
   end Arctan;
   
   ------------------
   -- Arctan_Cycle --
   ------------------
   
   function Arctan_Cycle
     (Y     : Float;
      X     : Float;
      Cycle : Float) return Float is
   begin
      return Maths_Functions.Arctan (Y, X, Cycle);
   end Arctan_Cycle;
   
   ------------
   -- Arccot --
   ------------
   
   function Arccot
     (X   : Float;
      Y   : Float) return Float is
   begin
      return Maths_Functions.Arccot (X, Y);
   end Arccot;
   
   ------------------
   -- Arccot_Cycle --
   ------------------
   
   function Arccot_Cycle
     (X     : Float;
      Y     : Float;
      Cycle : Float) return Float is
   begin
      return Maths_Functions.Arccot (X, Y, Cycle);
   end Arccot_Cycle;
   
   ---------
   -- Sin --
   ---------
   
   function Sinh (X : Float) return Float is
   begin
      return Maths_Functions.Sinh (X);
   end Sinh;
   
   ----------
   -- Cosh --
   ----------
   
   function Cosh (X : Float) return Float is
   begin
      return Maths_Functions.Cosh (X);
   end Cosh;
   
   ----------
   -- Tanh --
   ----------
   
   function Tanh (X : Float) return Float is
   begin
      return Maths_Functions.Tanh (X);
   end Tanh;
   
   ----------
   -- Coth --
   ----------
   
   function Coth (X : Float) return Float is
   begin
      return Maths_Functions.Coth (X);
   end Coth;
   
   -------------
   -- Arcsinh --
   -------------
   
   function Arcsinh (X : Float) return Float is
   begin
      return Maths_Functions.Arcsinh (X);
   end Arcsinh;
   
   -------------
   -- Arccosh --
   -------------
   
   function Arccosh (X : Float) return Float is
   begin
      return Maths_Functions.Arccosh (X);
   end Arccosh;
   
   -------------
   -- Arctanh --
   -------------
   
   function Arctanh (X : Float) return Float is
   begin
      return Maths_Functions.Arctanh (X);
   end Arctanh;
   
   -------------
   -- Arccoth --
   -------------
   
   function Arccoth (X : Float) return Float is
   begin
      return Maths_Functions.Arccoth (X);
   end Arccoth;
   
end Rxintr.Maths;
