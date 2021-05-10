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
-- Reflex is originally developed by Artics
------------------------------------------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;

with AUnit.Assertions; use AUnit.Assertions;

package body Rx.Containers.Lists.Tests is

   procedure Set_Up (T : in out Test_Case) is
   begin
      --  Do any necessary set ups.  If there are none,
      --  omit from both spec and body, as a default
      --  version is provided in Test_Cases.
      null;
   end Set_Up;


   procedure Tear_Down (T : in out Test_Case) is
   begin
      --  Do any necessary cleanups, so the next test
      --  has a clean environment.  If there is no
      --  cleanup, omit spec and body, as default is
      --  provided in Test_Cases.
      null;
   end Tear_Down;


   ---------------------
   -- Test_Initialize --
   ---------------------

   procedure Test_Initialize
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Initialize : testing Bad ");
   end Test_Initialize;
   
   
   ----------------
   -- Initialize --
   ----------------

   procedure Test_Lists_Initialize
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This  : Lists_Record;
      L     : Integer;
      E     : Integer;
      Lfrst : Integer;
      Efrst : Integer;
   begin
      Lists_Initialize (This);
      
      for I in List_Id range List_Id'First + 1 .. List_Id'Last loop
	 Assert
	   (This.Lists_Table (I) = No_List_Header,
	    "Test_Lists_Initialize: This.Lists_Table (I) := No_List_Header" &
	      " -- I = " & I'Img);
      end loop;
      
      for I in Entry_Id range Entry_Id'First + 1 .. Entry_Id'Last loop
	 Assert
	   (This.Entries_Table (I) = No_Entry_Record,
	    "Test_Lists_Initialize: This.Entries_Table (I) := No_Entry_Record"
	      & " -- I = " & I'Img);
      end loop;
      
      Lfrst := Integer (List_Id'First);
      L   := Integer (This.Lists_Count);
      Assert
	(This.Lists_Count = List_Id'First,
	 "Test_Lists_Initialize: This.Lists_Count = List_Id'First " &
	" -- List_Id'First = " & Lfrst'Img & " -- Found = " &  L'Img);
      
      Efrst := Integer (Entry_Id'First);
      E    := Integer (This.Entries_Count);
      Assert
        (This.Entries_Count = Entry_Id'First,
         "Test_Lists_Initialize: This.Entries_Count = Entry_Id'First " &
        "  -- Entry_Id'First = " & Efrst'Img & "  -- Found = " & E'Img);
      
      Assert (True, "Initialize : testing Bad ");
   end Test_Lists_Initialize;

   --------------
   -- New_List --
   --------------

   procedure Test_New_List 
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
   begin
      Lists_Initialize (This);
      
      New_List (This, L);
      
      Assert
	(This.Lists_Count = List_Id'First + 1,
	 "Test_New_List: This.Lists_Count := List_Id'First + 1" &
	   " -- Found = " & L'Img);
      Assert
	(L = This.Lists_Count,
	 "Test_New_List: (1) L = This.Lists_Count" &
	   " -- Found = " & L'Img);
      Assert
	(This.Lists_Table (L) = No_List_Header,
	 "Test_New_List: This.Lists_Table (L) = No_List_Header");
      
      
      New_List (This, L);
      
      Assert
	(This.Lists_Count = List_Id'First + 2,
	 "Test_New_List: This.Lists_Count := List_Id'First + 2" &
	   " -- Found = " & L'Img);
      Assert
	(L = This.Lists_Count,
	 "Test_New_List: (2) L = This.Lists_Count" &
	   " -- Found = " & L'Img);
      Assert
	(This.Lists_Table (L) = No_List_Header,
	 "Test_New_List: This.Lists_Table (L) = No_List_Header");
      
      
      Assert (True, "Test_New_List : testing Bad ");
   end Test_New_List;

   ----------------
   -- Empty_List --
   ----------------
   
   procedure Test_Empty_List 
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      Assert 
	(Empty_List (This, L), "Test_Empty_List: L = No_List_Id");
      
      New_List (This, L);
      Assert 
	(Empty_List (This, L),
	 "Test_Empty_List: L = No_List_Id after New_List");
      
      Assert (True, "Test_Empty_List : testing Bad ");
   end Test_Empty_List;
   
   -----------
   -- First --
   -----------

   procedure Test_First_Entry
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      New_List (This, L);

      Assert
	(First_Entry (This, L) = No_Entry_Id,
	 "Test_First_Entry: First_Entry (This, L) = No_Entry_Id");
      
      This.Lists_Table (L).First_Entry := Entry_Id (2);
      Assert
	(First_Entry (This, L) = Entry_Id (2),
	 "Test_First_Entry: First_Entry (This, L) = Entry_Id (2)");
      
      Assert (True, "Test_First_Entry : testing Bad ");
   end Test_First_Entry;

   ----------
   -- Last --
   ----------

   procedure Test_Last_Entry
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      New_List (This, L);

      Assert
	(Last_Entry (This, L) = No_Entry_Id,
	 "Test_Last_Entry: Last_Entry (This, L) = No_Entry_Id");
      
      This.Lists_Table (L).Last_Entry := Entry_Id (2);
      Assert
	(Last_Entry (This, L) = Entry_Id (2),
	 "Test_Last_Entry: Last_Entry (This, L) = Entry_Id (2)");

      Assert (True, "Test_Last_Entry : testing Bad ");
   end Test_Last_Entry;

   ---------------
   -- Set_First --
   ---------------

   procedure Test_Set_First
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
      E    : Entry_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      New_List (This, L);
      
      E := 2;
      Set_First (This, L, 2);
      Assert
	(This.Lists_Table (L).First_Entry  = 2,
	 "Test_Set_First: Set_First_Entry (This, L, 2)");
      
      Assert (True, "Test_Set_First : testing Bad ");
   end Test_Set_First;

   --------------
   -- Set_Last --
   --------------

   procedure Test_Set_Last
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
      E    : Entry_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      New_List (This, L);
      
      E := 2;
      Set_last (This, L, 2);
      Assert
	(This.Lists_Table (L).Last_Entry  = 2,
	 "Test_Set_Last: Set_Last_Entry (This, L, 2)");
      
      Assert (True,  "Test_Set_Last: testing Bad ");
   end Test_Set_Last;

   -------------
   -- No_List --
   -------------

   procedure Test_No_List
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
   begin
      Lists_Initialize (This);
      
      L := No_List_Id;
      
      Assert 
	(No_List (L),
	 "Test_No_List: No_List (Ths, L)");
      
      New_List (This, L);
      
      Assert 
	(not No_List (L),
	 "Test_No_List: not No_List (Ths, L)");
      
      Assert (True, "Test_No_List : testing Bad ");
   end Test_No_List;

   --------------
   -- No_Entry --
   --------------

   procedure Test_No_Entry
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      E : Entry_Id;
   begin
      E := No_Entry_Id;
      
      Assert
	(No_Entry (E),
	 "Test_No_Entry : No_Entry (E) ");
      
      E := 2;
      Assert
	(not No_Entry (E),
	 "Test_No_Entry : not No_Entry (E) ");
      
      Assert (True, "Test_No_Entry : testing Bad ");
   end Test_No_Entry;

   ------------
   -- Append --
   ------------

   procedure Test_Append
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
      E    : Entry_Id;
   begin
      Lists_Initialize (This);
      
      New_List (This, L);
      
      E := 2;
      Append (This, L, E);
      Assert
	(This.Lists_Table (L).First_Entry = 2,
	 "Test_Append: (1) This.Table (L).First_Entry = 2");
      Assert
	(This.Lists_Table (L).Last_Entry = 2,
	 "Test_Append: (1) This.Table (L).last_Entry = 2");
      
      Assert
	(This.Entries_Table (2).List_Link = L,
	 "Test_Append: (1) This.Entries_Table (2).List_Link = L");
      Assert
	(This.Entries_Table (2).Previous = No_Entry_Id,
	 "Test_Append: (1) This.Entries_Table(2).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (2).Next = No_Entry_Id,
	 "Test_Append: (1) This.Entries_Table(2).Next = No_Entry_Id");
      
      E := 3;
      Append (This, L, E);
      Assert
	(This.Lists_Table (L).First_Entry = 2,
	 "Test_Append:(2) This.Table (L).First_Entry = 2");
      Assert
	(This.Lists_Table (L).Last_Entry = 3,
	 "Test_Append: (2) This.Table (L).last_Entry = 3");
      
      Assert
	(This.Entries_Table (3).List_Link = L,
	 "Test_Append: (2) This.Entries_Table (3).List_Link = L");
      Assert
	(This.Entries_Table (2).Previous = No_Entry_Id,
	 "Test_Append: (2) This.Entries_Table(2).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (2).Next = 3,
	 "Test_Append: (2) This.Entries_Table(2).Next = 3");
      Assert
	(This.Entries_Table (3).Previous = 2,
	 "Test_Append: (2) This.Entries_Table(3).Previous = 2");
      Assert
	(This.Entries_Table (3).Next = No_Entry_Id,
	 "Test_Append: (2) This.Entries_Table(3).Next = No_Entry_Id");
      
      
      E := 4;
      Append (This, L, E);
      Assert
	(This.Lists_Table (L).First_Entry = 2,
	 "Test_Append:(3) This.Table (L).First_Entry = 2");
      Assert
	(This.Lists_Table (L).Last_Entry = 4,
	 "Test_Append: (3) This.Table (L).last_Entry = 3");
      
      Assert
	(This.Entries_Table (2).List_Link = L,
	 "Test_Append: (3) This.Entries_Table (3).List_Link = L");
      Assert
	(This.Entries_Table (2).Previous = No_Entry_Id,
	 "Test_Append: (3) This.Entries_Table(2).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (2).Next = 3,
	 "Test_Append: (3) This.Entries_Table(2).Next = 3");
      Assert
	(This.Entries_Table (3).Previous = 2,
	 "Test_Append: (3) This.Entries_Table(3).Previous = 2");
      Assert
	(This.Entries_Table (3).Next = 4,
	 "Test_Append: (3) This.Entries_Table(3).Next = 4");
      Assert
	(This.Entries_Table (4).Previous = 3,
	 "Test_Append: (3) This.Entries_Table(4).Previous = 3");
      Assert
	(This.Entries_Table (4).Next = No_Entry_Id,
	 "Test_Append: (3) This.Entries_Table(4).Next = 4");
      
      
      Assert (True, "Test_Append : testing Bad ");
   end Test_Append;

   ------------
   -- Remove --
   ------------

   procedure Test_Remove
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
      E    : Entry_Id;
   begin
      Lists_Initialize (This);
      
      New_List (This, L);
      
      E := 2;
      Append (This, L, E);
      
      E := 3;
      Append (This, L, E);
      
      E := 4;
      Append (This, L, E);
      
      Remove (This, 3);
      Assert
	(This.Lists_Table (L).First_Entry = 2,
	 "Test_Remove:(3) This.Table (L).First_Entry = 2");
      Assert
	(This.Lists_Table (L).Last_Entry = 4,
	 "Test_Remove: (3) This.Table (L).last_Entry = 3");
      
      Assert
	(This.Entries_Table (2).List_Link = L,
	 "Test_Remove: (3) This.Entries_Table (3).List_Link = L");
      Assert
	(This.Entries_Table (2).Previous = No_Entry_Id,
	 "Test_Remove: (3) This.Entries_Table(2).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (2).Next = 4,
	 "Test_Remove: (3) This.Entries_Table(2).Next = 4");
      Assert
	(This.Entries_Table (3).Previous = No_Entry_Id,
	 "Test_Remove: (3) This.Entries_Table(3).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (3).Next = No_Entry_Id,
	 "Test_Remove: (3) This.Entries_Table(3).Next = No_Entry_Id");
      Assert
	(This.Entries_Table (4).Previous = 2,
	 "Test_Remove: (3) This.Entries_Table(4).Previous = 2");
      Assert
	(This.Entries_Table (4).Next = No_Entry_Id,
	 "Test_Remove: (3) This.Entries_Table(4).Next = No_Entry_Id");
      
      

      Assert (True, "Test_Remove : testing Bad ");
   end Test_Remove;

   -----------------
   -- Remove_Head --
   -----------------

   procedure Test_Remove_Head
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
      
      This : Lists_Record;
      L    : List_Id;
      E    : Entry_Id;
   begin
      Lists_Initialize (This);
      
      New_List (This, L);
      
      E := 2;
      Append (This, L, E);
      
      E := 3;
      Append (This, L, E);
      
      E := 4;
      Append (This, L, E);
      
      Remove_Head (This, L, E);
      Assert
	(E = 2, 
	 "Test_Remove_Head : (1) ");
      
      Assert
	(This.Lists_Table (L).First_Entry = 3,
	 "Test_Remove_Head:(1) This.Table (L).First_Entry = 3");
      Assert
	(This.Lists_Table (L).Last_Entry = 4,
	 "Test_Remove_Head: (1) This.Table (L).last_Entry = 4");
      
      Assert
	(This.Entries_Table (2).List_Link = No_List_Id,
	 "Test_Remove_Head: (3) This.Entries_Table (2).List_Link = No_List_Id");
      Assert
	(This.Entries_Table (2).Previous = No_Entry_Id,
	 "Test_Remove_Head: (2) This.Entries_Table (2).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (2).Next = No_Entry_Id,
	 "Test_Remove_Head: (2) This.Entries_Table(2).Next = 3");
      
      Assert
	(This.Entries_Table (3).List_Link = L,
	 "Test_Remove_Head: (3) This.Entries_Table (3).List_Link = L");
      Assert
	(This.Entries_Table (3).Previous = No_Entry_Id,
	 "Test_Remove_Head: (3) This.Entries_Table(3).Previous = No_Entry_Id");
      Assert
	(This.Entries_Table (3).Next = 4,
	 "Test_Remove_Head: (3) This.Entries_Table(3).Next = 4");
      
      Assert (True, "Test_Remove_Head : testing Bad ");
   end Test_Remove_Head;

   ----------------------
   -- Remove_From_Item --
   ----------------------

   procedure Test_Remove_From_Item
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Remove_From_Item : testing Bad ");
   end Test_Remove_From_Item;

   ---------------------
   -- Entry_From_Item --
   ---------------------

   procedure Test_Entry_From_Item
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Entry_From_Item : testing Bad ");
   end Test_Entry_From_Item;

   ---------------
   -- New_Entry --
   ---------------

   procedure Test_New_Entry
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_New_Entry : testing Bad ");
   end Test_New_Entry;

   ----------
   -- Next --
   ----------

   procedure Test_Next
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Next : testing Bad ");
   end Test_Next;

   --------------
   -- Previous --
   --------------

   procedure Test_Previous
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Previous : testing Bad ");
   end Test_Previous;

   ---------------
   -- List_Link --
   ---------------

   procedure Test_List_Link
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_List_Link : testing Bad ");
   end Test_List_Link;

   ----------
   -- Item --
   ----------

   procedure Test_Item 
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Item : testing Bad ");
   end Test_Item;

   --------------
   -- Set_Next --
   --------------

   procedure Test_Set_Next
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Set_Next : testing Bad ");
   end Test_Set_Next;

   ------------------
   -- Set_Previous --
   ------------------

   procedure Test_Set_Previous
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Set_Previous : testing Bad ");
   end Test_Set_Previous;

   -------------------
   -- Set_List_Link --
   -------------------

   procedure Test_Set_List_Link
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Set_List_Link : testing Bad ");
   end Test_Set_List_Link;

   --------------
   -- Set_Item --
   --------------

   procedure Test_Set_Item
     (R : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (True, "Test_Set_Item : testing Bad ");
   end Test_Set_Item;
   
   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use Test_Cases, Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Initialize'Access, "Test_Initialize");
      
      Register_Routine
	(T,  Test_Lists_Initialize'Access, "Test_Initialize");
      Register_Routine
	(T,  Test_New_List'Access, "Test_New_List");
      Register_Routine
	(T,  Test_Empty_List'Access, "Test_Empty_List");
      Register_Routine
	(T,  Test_First_Entry'Access, "Test_First_Entry");
      Register_Routine
	(T,  Test_Last_Entry'Access, "Test_Last_Entry");
      Register_Routine
	(T, Test_Set_First'Access, "Test_Set_First");
      Register_Routine
	(T, Test_Set_Last'Access, "Test_Set_Last");
      Register_Routine
	(T, Test_No_List'Access, "Test_No_List");
      Register_Routine
	(T, Test_No_Entry'Access, "Test_No_Entry");
      Register_Routine
	(T, Test_Append'Access, "Test_Append");
      Register_Routine
	(T, Test_Remove'Access, "Test_Remove");
      Register_Routine
	(T, Test_Remove_Head'Access, "Test_Remove_Head");
      Register_Routine 
	(T, Test_Remove_From_Item'Access, "Test_Remove_From_Item");
      Register_Routine
	(T, Test_Entry_From_Item'Access, "Test_Entry_From_Item");
      Register_Routine
	(T, Test_New_Entry'Access, "Test_New_Entry");
      Register_Routine
	(T, Test_Next'Access, "Test_Next");
      Register_Routine
	(T, Test_Previous'Access, "Test_Previous");
      Register_Routine
	(T, Test_List_Link'Access, "Test_List_Link");
      Register_Routine
	(T, Test_Item 'Access, "Test_Item");
      Register_Routine
	(T, Test_Set_Next'Access, "Test_Set_Next");
      Register_Routine
	(T, Test_Set_Previous'Access, "Test_Set_Previous");
      Register_Routine
	(T, Test_Set_List_Link'Access, "Test_Set_List_Link");
      Register_Routine
	(T, Test_Set_Item'Access, "Test_Set_Item");
      
   end Register_Tests;

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Rx.Containers.Lists.Tests: ");
   end Name;

end Rx.Containers.Lists.Tests;
