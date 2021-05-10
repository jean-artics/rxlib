------------------------------------------------------------------------------
--                                                                          --
--                         REFLEX LIBRARY COMPONENTS                        --
--                                                                          --
--                               N L I S T S                                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2010, Free Software Foundation, Inc.         --
--                                                                          --
-- Reflex is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  Reflex is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- Reflex was developed  by Artics.
--                                                                          --
------------------------------------------------------------------------------

with Rxrt.Table;

with Rxrt.Tasks; use Rxrt.Tasks;

package body Rxrt.Tlists is

   ----------------------------------
   -- Implementation of Tsk Lists --
   ----------------------------------

   --  A Tsk list is represented by a list header which contains
   --  three fields:

   type List_Header is record
      First : Task_Id;
      --  Pointer to first Tsk in list. Empty if list is empty

      Last : Task_Id;
      --  Pointer to last Tsk in list. Empty if list is empty

      Parent : Task_Id;
      --  Pointer to parent of list. Empty if list has no parent
   end record;

   --  The Tsk lists are stored in a table indexed by Task_List_Id values

   package Lists is new Rxrt.Table.Table (
     Table_Component_Type => List_Header,
     Table_Index_Type     => Task_List_Id'Base,
     Table_Low_Bound      => First_Task_List_Id,
     Table_Initial        => Lists_Initial,
     Table_Increment      => Lists_Increment,
     Table_Name           => "Lists");

   --  The Tsks in the list all have the In_List flag set, and their Link
   --  fields (which otherwise point to the parent) contain the Task_List_Id of
   --  the list header giving immediate access to the list containing the
   --  Tsk, and its parent and first and last elements.

   --  Two auxiliary tables, indexed by Task_Id values and built in parallel
   --  with the main nodes table and always having the same size contain the
   --  list link values that allow locating the previous and next node in a
   --  list. The entries in these tables are valid only if the In_List flag
   --  is set in the corresponding node. Next_Task is Empty at the end of a
   --  list and Prev_Node is Empty at the start of a list.

   package Next_Task is new Rxrt.Table.Table (
      Table_Component_Type => Task_Id,
      Table_Index_Type     => Task_Id'Base,
      Table_Low_Bound      => First_Task_Id,
      Table_Initial        => Tasks_Initial,
      Table_Increment      => Tasks_Increment,
      Table_Name           => "Next_Task");

   package Prev_Task is new Rxrt.Table.Table (
      Table_Component_Type => Task_Id,
      Table_Index_Type     => Task_Id'Base,
      Table_Low_Bound      => First_Task_Id,
      Table_Initial        => Tasks_Initial,
      Table_Increment      => Tasks_Increment,
      Table_Name           => "Prev_Pask");

   -----------------------
   -- Local Subprograms --
   -----------------------

   procedure Set_First (List : Task_List_Id; To : Task_Id);
   pragma Inline (Set_First);
   --  Sets First field of list header List to reference To

   procedure Set_Last (List : Task_List_Id; To : Task_Id);
   pragma Inline (Set_Last);
   --  Sets Last field of list header List to reference To

   procedure Set_Next (Tsk : Task_Id; To : Task_Id);
   pragma Inline (Set_Next);
   --  Sets the Next_Task pointer for Tsk to reference To

   procedure Set_Prev (Tsk : Task_Id; To : Task_Id);
   pragma Inline (Set_Prev);
   --  Sets the Prev_Task pointer for Tsk to reference To

   procedure Set_Parent (List : Task_List_Id; Tsk : Task_Id);
   pragma Inline (Set_Parent);
   --  Sets the Prev_Task pointer for Tsk to reference To

   --------------------------
   -- Allocate_List_Tables --
   --------------------------

   procedure Allocate_List_Tables (Tsk : Task_Id) is
      Old_Last : constant Task_Id'Base := Next_Task.Last;

   begin
      pragma Assert (Tsk >= Old_Last);
      Next_Task.Set_Last (Tsk);
      Prev_Task.Set_Last (Tsk);

      --  Make sure we have no uninitialized junk in any new entires added.
      --  This ensures that Tree_Gen will not write out any uninitialized junk.

      for J in Old_Last + 1 .. Tsk loop
         Next_Task.Table (J) := No_Task_Id;
         Prev_Task.Table (J) := No_Task_Id;
      end loop;
   end Allocate_List_Tables;

   ------------
   -- Append --
   ------------

   procedure Append (Tsk : Task_Id; To : Task_List_Id) is
      L : constant Task_Id := Last (To);

   --  Start of processing for Append

   begin
      pragma Assert (not In_List (Tsk));

      if Tsk = No_Task_Id then
         return;
      end if;

      if No (L) then
         Set_First (To, Tsk);
      else
         Set_Next (L, Tsk);
      end if;

      Set_Last (To, Tsk);

      Set_Next      (Tsk, No_Task_Id);
      Set_Prev      (Tsk, L);
      Set_List_Link (Tsk, To);
   end Append;

   -----------------
   -- Append_List --
   -----------------

   procedure Append_List (List : Task_List_Id; To : Task_List_Id) is

   --  Start of processing for Append_List

   begin
      if Is_Empty_List (List) then
         return;

      else
         declare
            L : constant Task_Id := Last (To);
            F : constant Task_Id := First (List);
            N : Task_Id;

         begin
            N := F;
            loop
               Set_List_Link (N, To);
               N := Next (N);
               exit when No (N);
            end loop;

            if No (L) then
               Set_First (To, F);
            else
               Set_Next (L, F);
            end if;

            Set_Prev (F, L);
            Set_Last (To, Last (List));

            Set_First (List, No_Task_Id);
            Set_Last  (List, No_Task_Id);
         end;
      end if;
   end Append_List;

   --------------------
   -- Append_List_To --
   --------------------

   procedure Append_List_To (To : Task_List_Id; List : Task_List_Id) is
   begin
      Append_List (List, To);
   end Append_List_To;

   ---------------
   -- Append_To --
   ---------------

   procedure Append_To (To : Task_List_Id; Tsk : Task_Id) is
   begin
      Append (Tsk, To);
   end Append_To;

   -----------
   -- First --
   -----------

   function First (List : Task_List_Id) return Task_Id is
   begin
      if List = No_Task_List_Id then
         return No_Task_Id;
      else
         pragma Assert (List <= Lists.Last);
         return Lists.Table (List).First;
      end if;
   end First;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      E : constant Task_List_Id := No_Task_List_id;

   begin
      Lists.Init;
      Next_Task.Init;
      Prev_Task.Init;

      --  Allocate Error_List list header

      Lists.Increment_Last;
      Set_Parent (E, No_Task_Id);
      Set_First  (E, No_Task_Id);
      Set_Last   (E, No_Task_Id);
   end Initialize;

   ------------------
   -- In_Same_List --
   ------------------

   function In_Same_List (T1, T2 : Task_Id) return Boolean is
   begin
      return List_Link (T1) = List_Link (T2);
   end In_Same_List;

   ------------------
   -- Insert_After --
   ------------------

   procedure Insert_After
     (After : Task_Id;
      Tsk  : Task_Id)
   is
   --  Start of processing for Insert_After

   begin
      pragma Assert
        (In_List (After) and then not In_List (Tsk));

      if Tsk = No_Task_Id then
         return;
      end if;

      declare
         Before : constant Task_Id := Next (After);
         LC     : constant Task_List_Id           := List_Link (After);

      begin
         if Present (Before) then
            Set_Prev (Before, Tsk);
         else
            Set_Last (LC, Tsk);
         end if;

         Set_Next (After, Tsk);

         Set_Prev      (Tsk, After);
         Set_Next      (Tsk, Before);
         Set_List_Link (Tsk, LC);
      end;
   end Insert_After;

   -------------------
   -- Insert_Before --
   -------------------

   procedure Insert_Before
     (Before : Task_Id;
      Tsk    : Task_Id)
   is
   --  Start of processing for Insert_Before

   begin
      pragma Assert
        (In_List (Before) and then not In_List (Tsk));

      if Tsk = No_Task_Id then
         return;
      end if;

      declare
         After : constant Task_Id := Prev (Before);
         LC    : constant Task_List_Id           := List_Link (Before);

      begin
         if Present (After) then
            Set_Next (After, Tsk);
         else
            Set_First (LC, Tsk);
         end if;

         Set_Prev (Before, Tsk);

         Set_Prev      (Tsk, After);
         Set_Next      (Tsk, Before);
         Set_List_Link (Tsk, LC);
      end;
   end Insert_Before;

   -----------------------
   -- Insert_List_After --
   -----------------------

   procedure Insert_List_After (After : Task_Id; List : Task_List_Id) is

   --  Start of processing for Insert_List_After

   begin
      pragma Assert (In_List (After));

      if Is_Empty_List (List) then
         return;

      else
         declare
            Before : constant Task_Id := Next (After);
            LC     : constant Task_List_Id           := List_Link (After);
            F      : constant Task_Id := First (List);
            L      : constant Task_Id := Last (List);
            N      : Task_Id;

         begin
            N := F;
            loop
               Set_List_Link (N, LC);
               exit when N = L;
               N := Next (N);
            end loop;

            if Present (Before) then
               Set_Prev (Before, L);
            else
               Set_Last (LC, L);
            end if;

            Set_Next (After, F);
            Set_Prev (F, After);
            Set_Next (L, Before);

            Set_First (List, No_Task_Id);
            Set_Last  (List, No_Task_Id);
         end;
      end if;
   end Insert_List_After;

   ------------------------
   -- Insert_List_Before --
   ------------------------

   procedure Insert_List_Before (Before : Task_Id; List : Task_List_Id) is

   --  Start of processing for Insert_List_Before

   begin
      pragma Assert (In_List (Before));

      if Is_Empty_List (List) then
         return;

      else
         declare
            After : constant Task_Id := Prev (Before);
            LC    : constant Task_List_Id           := List_Link (Before);
            F     : constant Task_Id := First (List);
            L     : constant Task_Id := Last (List);
            N     : Task_Id;

         begin
            N := F;
            loop
               Set_List_Link (N, LC);
               exit when N = L;
               N := Next (N);
            end loop;

            if Present (After) then
               Set_Next (After, F);
            else
               Set_First (LC, F);
            end if;

            Set_Prev (Before, L);
            Set_Prev (F, After);
            Set_Next (L, Before);

            Set_First (List, No_Task_Id);
            Set_Last  (List, No_Task_Id);
         end;
      end if;
   end Insert_List_Before;

   -------------------
   -- Is_Empty_List --
   -------------------

   function Is_Empty_List (List : Task_List_Id) return Boolean is
   begin
      return First (List) = No_Task_Id;
   end Is_Empty_List;

   -----------------------
   -- Is_Non_Empty_List --
   -----------------------

   function Is_Non_Empty_List (List : Task_List_Id) return Boolean is
   begin
      return First (List) /= No_Task_Id;
   end Is_Non_Empty_List;

   ----------
   -- Last --
   ----------

   function Last (List : Task_List_Id) return Task_Id is
   begin
      pragma Assert (List <= Lists.Last);
      return Lists.Table (List).Last;
   end Last;

   ------------------
   -- Last_List_Id --
   ------------------

   function Last_List_Id return Task_List_Id is
   begin
      return Lists.Last;
   end Last_List_Id;

   -----------------
   -- List_Length --
   -----------------

   function List_Length (List : Task_List_Id) return Natural is
      Result : Natural;
      Tsk   : Task_Id;

   begin
      Result := 0;
      Tsk := First (List);
      while Present (Tsk) loop
         Result := Result + 1;
         Tsk := Next (Tsk);
      end loop;

      return Result;
   end List_Length;

   -------------------
   -- Lists_Address --
   -------------------

   function Lists_Address return System.Address is
   begin
      return Lists.Table (First_Task_List_Id)'Address;
   end Lists_Address;

   --------------
   -- New_List --
   --------------

   function New_List return Task_List_Id is

   --  Start of processing for New_List

   begin
      Lists.Increment_Last;

      declare
         List : constant Task_List_Id := Lists.Last;

      begin
         Set_Parent (List, No_Task_Id);
         Set_First  (List, No_Task_Id);
         Set_Last   (List, No_Task_Id);

         return (List);
      end;
   end New_List;

   --  Since the one argument case is common, we optimize to build the right
   --  list directly, rather than first building an empty list and then doing
   --  the insertion, which results in some unnecessary work.

   function New_List (Tsk : Task_Id) return Task_List_Id is

   --  Start of processing for New_List

   begin
      if Tsk = No_Task_Id then
         return New_List;

      else
         pragma Assert (not In_List (Tsk));

         Lists.Increment_Last;

         declare
            List : constant Task_List_Id := Lists.Last;

         begin
            Set_Parent (List, No_Task_Id);
            Set_First  (List, Tsk);
            Set_Last   (List, Tsk);

            Set_List_Link (Tsk, List);
            Set_Prev (Tsk, No_Task_Id);
            Set_Next (Tsk, No_Task_Id);
	    
            return List;
         end;
      end if;
   end New_List;

   function New_List
     (Tsk1 : Task_Id;
      Tsk2 : Task_Id) return Task_List_Id
   is
      L : constant Task_List_Id := New_List (Tsk1);
   begin
      Append (Tsk2, L);
      return L;
   end New_List;

   ----------
   -- Next --
   ----------

   function Next (Tsk : Task_Id) return Task_Id is
   begin
      pragma Assert (In_List (Tsk));
      return Next_Task.Table (Tsk);
   end Next;

   procedure Next (Tsk : in out Task_Id) is
   begin
      Tsk := Next (Tsk);
   end Next;

   -----------------------
   -- Next_Task_Address --
   -----------------------

   function Next_Task_Address return System.Address is
   begin
      return Next_Task.Table (First_Task_Id)'Address;
   end Next_Task_Address;

   --------
   -- No --
   --------

   function No (List : Task_List_Id) return Boolean is
   begin
      return List = No_Task_List_Id;
   end No;

   ---------------
   -- Num_Lists --
   ---------------

   function Num_Lists return Natural is
   begin
      return Integer (Lists.Last) - Integer (Lists.First) + 1;
   end Num_Lists;

   ------------
   -- Parent --
   ------------

   function Parent (List : Task_List_Id) return Task_Id is
   begin
      pragma Assert (List <= Lists.Last);
      return Lists.Table (List).Parent;
   end Parent;

   ----------
   -- Pick --
   ----------

   function Pick (List : Task_List_Id; Index : Positive) return Task_Id is
      Elmt : Task_Id;

   begin
      Elmt := First (List);
      for J in 1 .. Index - 1 loop
         Elmt := Next (Elmt);
      end loop;

      return Elmt;
   end Pick;

   -------------
   -- Prepend --
   -------------

   procedure Prepend (Tsk : Task_Id; To : Task_List_Id) is
      F : constant Task_Id := First (To);

   --  Start of processing for Prepend_Debug

   begin
      pragma Assert (not In_List (Tsk));

      if Tsk = No_Task_Id then
         return;
      end if;

      if No (F) then
         Set_Last (To, Tsk);
      else
         Set_Prev (F, Tsk);
      end if;

      Set_First (To, Tsk);

      Set_Next      (Tsk, F);
      Set_Prev      (Tsk, No_Task_Id);
      Set_List_Link (Tsk, To);
   end Prepend;

   ------------------
   -- Prepend_List --
   ------------------

   procedure Prepend_List (List : Task_List_Id; To : Task_List_Id) is

   --  Start of processing for Prepend_List

   begin
      if Is_Empty_List (List) then
         return;

      else
         declare
            F : constant Task_Id := First (To);
            L : constant Task_Id := Last (List);
            N : Task_Id;

         begin
            N := L;
            loop
               Set_List_Link (N, To);
               N := Prev (N);
               exit when No (N);
            end loop;

            if No (F) then
               Set_Last (To, L);
            else
               Set_Next (L, F);
            end if;

            Set_Prev (F, L);
            Set_First (To, First (List));

            Set_First (List, No_Task_Id);
            Set_Last  (List, No_Task_Id);
         end;
      end if;
   end Prepend_List;

   ---------------------
   -- Prepend_List_To --
   ---------------------

   procedure Prepend_List_To (To : Task_List_Id; List : Task_List_Id) is
   begin
      Prepend_List (List, To);
   end Prepend_List_To;

   ----------------
   -- Prepend_To --
   ----------------

   procedure Prepend_To (To : Task_List_Id; Tsk : Task_Id) is
   begin
      Prepend (Tsk, To);
   end Prepend_To;

   -------------
   -- Present --
   -------------

   function Present (List : Task_List_Id) return Boolean is
   begin
      return List /= No_Task_List_Id;
   end Present;

   ----------
   -- Prev --
   ----------

   function Prev (Tsk : Task_Id) return Task_Id is
   begin
      pragma Assert (In_List (Tsk));
      return Prev_Task.Table (Tsk);
   end Prev;

   procedure Prev (Tsk : in out Task_Id) is
   begin
      Tsk := Prev (Tsk);
   end Prev;

   -----------------------
   -- Prev_Task_Address --
   -----------------------

   function Prev_Task_Address return System.Address is
   begin
      return Prev_Task.Table (First_Task_Id)'Address;
   end Prev_Task_Address;

   ------------
   -- Remove --
   ------------

   procedure Remove (Tsk : Task_Id) is
      Lst : constant Task_List_Id           := List_Link (Tsk);
      Prv : constant Task_Id := Prev (Tsk);
      Nxt : constant Task_Id := Next (Tsk);

   --  Start of processing for Remove

   begin
      if No (Prv) then
         Set_First (Lst, Nxt);
      else
         Set_Next (Prv, Nxt);
      end if;

      if No (Nxt) then
         Set_Last (Lst, Prv);
      else
         Set_Prev (Nxt, Prv);
      end if;

      Set_List_Link (Tsk, No_Task_List_Id);
      Set_Parent (Tsk, No_Task_Id);
   end Remove;

   -----------------
   -- Remove_Head --
   -----------------

   function Remove_Head (List : Task_List_Id) return Task_Id is
      Frst : constant Task_Id := First (List);

   --  Start of processing for Remove_Head

   begin
      if Frst = No_Task_Id then
         return No_Task_Id;

      else
         declare
            Nxt : constant Task_Id := Next (Frst);

         begin
            Set_First (List, Nxt);

            if No (Nxt) then
               Set_Last (List, No_Task_Id);
            else
               Set_Prev (Nxt, No_Task_Id);
            end if;

            Set_List_Link (Frst, No_Task_List_Id);
            return Frst;
         end;
      end if;
   end Remove_Head;

   -----------------
   -- Remove_Next --
   -----------------

   function Remove_Next
     (Tsk : Task_Id) return Task_Id
   is
      Nxt : constant Task_Id := Next (Tsk);

   --  Start of processing for Remove_Next

   begin
      if Present (Nxt) then
         declare
            Nxt2 : constant Task_Id := Next (Nxt);
            LC   : constant Task_List_Id           := List_Link (Tsk);

         begin
            Set_Next (Tsk, Nxt2);

            if No (Nxt2) then
               Set_Last (LC, Tsk);
            else
               Set_Prev (Nxt2, Tsk);
            end if;

            Set_List_Link (Nxt, No_Task_Id);
         end;
      end if;

      return Nxt;
   end Remove_Next;

   ---------------
   -- Set_First --
   ---------------

   procedure Set_First (List : Task_List_Id; To : Task_Id) is
   begin
      Lists.Table (List).First := To;
   end Set_First;

   --------------
   -- Set_Last --
   --------------

   procedure Set_Last (List : Task_List_Id; To : Task_Id) is
   begin
      Lists.Table (List).Last := To;
   end Set_Last;

   --------------
   -- Set_Next --
   --------------

   procedure Set_Next (Tsk : Task_Id; To : Task_Id) is
   begin
      Next_Task.Table (Tsk) := To;
   end Set_Next;

   ----------------
   -- Set_Parent --
   ----------------

   procedure Set_Parent (List : Task_List_Id; Tsk : Task_Id) is
   begin
      pragma Assert (List <= Lists.Last);
      Lists.Table (List).Parent := Tsk;
   end Set_Parent;

   --------------
   -- Set_Prev --
   --------------

   procedure Set_Prev (Tsk : Task_Id; To : Task_Id) is
   begin
      Prev_Task.Table (Tsk) := To;
   end Set_Prev;

end Rxrt.Tlists;
