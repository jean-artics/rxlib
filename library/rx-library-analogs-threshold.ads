-----------------------------------------------------------------------
--                       Reflex Library                              --
--                                                                   --
--              Copyright (C) 2012-2014, Artics                      --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

--  This package implements Threshold.
--  It provides :
--  - Threshold, a six thresholds box.

package Rx.Library.Analogs.Threshold is

   type Threshold_Record is tagged private;

   procedure Initialise
     (This       : in out Threshold_Record;
      Hysteresis : Float;
      HHH_T      : Float;
      HH_T       : Float;
      H_T        : Float;
      L_T        : Float;
      LL_T       : Float;
      LLL_T      : Float);

   procedure Cyclic
     (This  : in out Threshold_Record;
      Value : in Float;
      HHH   : out Boolean;
      HH    : out Boolean;
      H     : out Boolean;
      L     : out Boolean;
      LL    : out Boolean;
      LLL   : out Boolean);

private

   type Threshold_Record is tagged record
         Hysteresis : Float;
         HHH_T      : Float;
         HH_T       : Float;
         H_T        : Float;
         L_T        : Float;
         LL_T       : Float;
         LLL_T      : Float;
         HHH        : Boolean;
         HH         : Boolean;
         H          : Boolean;
         L          : Boolean;
         LL         : Boolean;
         LLL        : Boolean;
      end record;
   
   No_Threshold_Record : constant Threshold_Record :=
     Threshold_Record'
     (Hysteresis => 0.0,
      HHH_T      => 0.0,
      HH_T       => 0.0,
      H_T        => 0.0,
      L_T        => 0.0,
      LL_T       => 0.0,
      LLL_T      => 0.0,
      HHH        => False,
      HH         => False,
      H          => False,
      L          => False,
      LL         => False,
      LLL        => False);

end Rx.Library.Analogs.Threshold;
