-----------------------------------------------------------------------
--                       Reflex Run Time                             --
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

package Rxrt.Handler is
   
   procedure Initialize_Run_Time;
   -- Do the initioalizzation of all modules of the reflex run time. 
   
   procedure Pre_Processing;
   -- Call at the beginning of each instant, before calling the application
   -- cycle
   
   procedure Post_Processing;
   -- Call at the end of each instant, after the application cycle
   
   procedure Initialize_Application;
   -- Call to initialize the application. The application tasks are created 
   -- here
   
   procedure Run;
   -- Start the reflex approgram
   
   pragma Export (Ada, Initialize_Run_Time, "Rxrt_Initialize_Run_Time");
   pragma Export (Ada, Initialize_Application, "Rxrt_Initialize_Application");
   pragma Export (Ada, Run, "Rxrt_Run");
     
end Rxrt.Handler;
