-----------------------------------------------------------------------
--                          Reflex Library                           --
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

package Rx.Sys.Task_Interfaces is

   type Task_Control_Type is record
      Quit           : Boolean := False;
      Start_Watching : Boolean := False;
      Run            : Boolean := False;
   end record;
   
   protected type Task_Control is

      procedure Quit (Value : in Boolean);
      function Quit return Boolean;
      
      procedure Start_Watching (Value : in Boolean);
      function Start_Watching return Boolean;

      procedure Run (Value : in Boolean);
      function Run return Boolean;

   private
      
      Control : Task_Control_Type;
   end Task_Control;

   type Task_Status_Type is record
      Ready        : Boolean  := False;
      Terminated   : Boolean  := False;
      Running      : Boolean  := False;
      
      Min_Duration : Duration := 0.0;
      Max_Duration : Duration := 0.0;
      Avg_Duration : Duration := 0.0;
   end record;

   protected type Task_Status is

      procedure Ready (Value : in Boolean);
      function Ready return Boolean;

      procedure Terminated (Value : in Boolean);
      function Terminated return Boolean;

      procedure Running (Value : in Boolean);
      function Running return Boolean;

      procedure Min_Duration (Value : in Duration);
      procedure Max_Duration (Value : in Duration);
      procedure Avg_Duration (Value : in Duration);

      function Get_Status return Task_Status_Type;

   private
      Status : Task_Status_Type;
   end Task_Status;

end Rx.Sys.Task_Interfaces;
