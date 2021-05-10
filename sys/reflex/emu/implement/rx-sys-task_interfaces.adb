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

package body Rx.Sys.Task_Interfaces is

   protected body Task_Control is

      procedure Quit (Value : in Boolean) is
      begin
         Control.Quit := Value;
      end Quit;

      function Quit return Boolean is
      begin
         return Control.Quit;
      end Quit;

      procedure Start_Watching (Value : in Boolean) is
      begin
         Control.Start_Watching := Value;
      end Start_Watching;

      function Start_Watching return Boolean is
      begin
         return Control.Start_Watching;
      end Start_Watching;

      procedure Run (Value : in Boolean) is
      begin
         Control.Run := Value;
      end Run;

      function Run return Boolean is
      begin
         return Control.Run;
      end Run;

   end Task_Control;

   protected body Task_Status is

      procedure Ready (Value : in Boolean) is
      begin
         Status.Ready := Value;
      end Ready;

      function Ready return Boolean is
      begin
         return Status.Ready;
      end Ready;

      procedure Terminated (Value : in Boolean) is
      begin
         Status.Terminated := Value;
      end Terminated;

      function Terminated return Boolean is
      begin
         return Status.Terminated;
      end Terminated;

      procedure Running (Value : in Boolean) is
      begin
         Status.Running := Value;
      end Running;

      function Running return Boolean is
      begin
         return Status.Running;
      end Running;

      procedure Min_Duration (Value : in Duration) is
      begin
         Status.Min_Duration := Value;
      end Min_Duration;

      procedure Max_Duration (Value : in Duration) is
      begin
         Status.Max_Duration := Value;
      end Max_Duration;

      procedure Avg_Duration (Value : in Duration) is
      begin
         Status.Avg_Duration := Value;
      end Avg_Duration;

      function Get_Status return Task_Status_Type is
      begin
         return Status;
      end Get_Status;

   end Task_Status;

end Rx.Sys.Task_Interfaces;
