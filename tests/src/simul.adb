------------------------------------------------------------------------------
--                                                                          --
--                                REFLEX DE%O                               --
--                                                                          --
--          Copyright (C) 2016, Free Software Foundation, Inc.              --
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
-- Reflex is originally developed by Artics                                 --
------------------------------------------------------------------------------

with Ada.Text_Io; use Ada.Text_Io;
--  with Logutils; use Logutils;

with Rxrt.RxClock; use Rxrt.RxClock;

package body Simul is
   
   ---------------------
   -- Simul_Initialze --
   ---------------------
   
   procedure Initialize is
   begin
      null;
   end Initialize;
   
   ------------------
   -- Simul_Cyclic --
   ------------------
   
   procedure Cyclic is
   begin
      Put_Line ("Simul Cyclic");
      
      Put_Line ("     Clock => " & Rxrt.RxClock.Clock'Img);
   end Cyclic;
   
   ----------------------
   -- Simul_Get_Inputs --
   ----------------------
   
   procedure Simul_Get_Inputs is
   begin
      null;
   end Simul_Get_Inputs;
   
   -----------------------
   -- Simul_Set_Outputs --
   -----------------------
   
   procedure Simul_Set_Outputs is
   begin
      null;
   end Simul_Set_Outputs;
   
end Simul;
