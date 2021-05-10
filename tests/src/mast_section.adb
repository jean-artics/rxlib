-- Reflex code generated from file : mast_section.glips

with Ada.text_Io; use Ada.text_IO;

with Rxrt.RxClock; use Rxrt.RxClock;
 
package body Mast_Section is
 
 
 
   ------------------
   --  Initialize  --
   ------------------
 
   procedure Initialize 
   is
   begin
      null;
   end Initialize;
 
 
   --------------------
   --  Scale_Inputs  --
   --------------------
 
   procedure Scale_Inputs 
   is
   begin
      null; 
   end Scale_Inputs;
 
 
   --------------
   --  Cyclic  --
   --------------
 
   procedure Cyclic 
   is
   begin
      Put_Line ("Mast");
      Put_Line ("    Clock => " & Rxrt.Rxclock.Clock'Img);
   end Cyclic;
 
 
   ---------------------
   --  Scale_Outputs  --
   ---------------------
 
   procedure Scale_Outputs 
   is
   begin
      null; 
   end Scale_Outputs;
 
end Mast_Section;

