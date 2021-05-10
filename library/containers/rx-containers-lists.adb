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

package body Rx.Containers.Lists is

   ----------------
   -- Initialize --
   ----------------

   procedure Lists_Initialize (This : in out Lists_Record) is
   begin
      This.Lists_Table   := Lists_Array'(others   => No_List_Header);
      This.Entries_Table := Entries_Array'(others => No_Entry_Record);
      This.Lists_Count   := No_List_Id;
      This.Entries_Count := No_Entry_Id;
   end Lists_Initialize;

   --------------
   -- New_List --
   --------------

   procedure New_List 
     (This : in out Lists_Record;
      Nl   : out List_Id) is
   begin
      This.Lists_Count := This.Lists_Count + 1;
      This.Lists_Table (This.Lists_Count) := No_List_Header;
      Nl := This.Lists_Count;
   end New_List;

   ----------------
   -- Empty_List --
   ----------------
   
   function Empty_List 
     (This : in Lists_Record;
      L    : List_Id) return Boolean is
   begin
      return L = No_List_Id or else This.First_Entry (L) = No_Entry_Id;
   end Empty_List;
   
   -----------
   -- First --
   -----------

   function First_Entry
     (This : in Lists_Record;
      L    : List_Id) return Entry_Id is
   begin
      return This.Lists_Table (L).First_Entry;
   end First_Entry;

   ----------
   -- Last --
   ----------

   function Last_Entry
     (This : in Lists_Record;
      L    : List_Id) return Entry_Id is
   begin
      return This.Lists_Table (L).Last_Entry;
   end Last_Entry;

   ---------------
   -- Set_First --
   ---------------

   procedure Set_First
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id) is
   begin
      This.Lists_Table (L).First_Entry := E;
   end Set_First;

   --------------
   -- Set_Last --
   --------------

   procedure Set_Last
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id) is
   begin
      This.Lists_Table (L).Last_Entry := E;
   end Set_Last;

   -------------
   -- No_List --
   -------------

   function No_List (L : List_Id) return Boolean is
   begin
      return L = No_List_Id;
   end No_List;

   --------------
   -- No_Entry --
   --------------

   function No_Entry (E : Entry_Id) return Boolean is
   begin
      return E = No_Entry_Id;
   end No_Entry;

   ------------
   -- Append --
   ------------

   procedure Append
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id)
   is
      Lst : constant Entry_Id := This.Last_Entry (L);
   begin
      if No_Entry (Lst) then
         This.Set_First (L, E);
      else
         This.Set_Next (Lst, E);
      end if;

      This.Set_Last (L, E);

      This.Set_Next      (E, No_Entry_Id);
      This.Set_Previous  (E, Lst);
      This.Set_List_Link (E, L);
   end Append;

   ------------
   -- Remove --
   ------------

   procedure Remove
     (This : in out Lists_Record;
      E    : Entry_Id) is
      
      Lst : List_Id;
      Prv : Entry_Id;
      Nxt : Entry_Id;
   begin
      Lst := This.List_Link (E);
      if Lst /= No_List_Id then
	 Prv := This.Previous (E);
	 Nxt := This.Next (E);
	 
	 if No_Entry (Prv) then
	    This.Set_First (Lst, Nxt);
	 else
	    This.Set_Next (Prv, Nxt);
	 end if;
	 
	 if No_Entry (Nxt) then
	    This.Set_Last (Lst, Prv);
	 else
	    This.Set_Previous (Nxt, Prv);
	 end if;
	 
	 This.Set_List_Link (E, No_List_Id);
	 This.Set_Previous (E, No_Entry_Id);
	 This.Set_Next (E, No_Entry_Id);
      end if;
   end Remove;

   -----------------
   -- Remove_Head --
   -----------------

   procedure Remove_Head
     (This : in out Lists_Record;
      L    : List_Id;
      E    : out Entry_Id) is
      
      Frst : Entry_Id;
      Nxt  : Entry_Id;
   begin
      Frst := This.First_Entry (L);

      if Frst /= No_Entry_Id then
	 Nxt := This.Next (Frst);
	 This.Set_First (L, Nxt);

	 if No_Entry (Nxt) then
	    This.Set_Last (L, No_Entry_Id);
	 else
	    This.Set_Previous (Nxt, No_Entry_Id);
	 end if;

	 This.Set_List_Link (Frst, No_List_Id);
	 This.Set_Previous (Frst, No_Entry_Id);
	 This.Set_Next (Frst, No_Entry_Id);
      end if;

      E := Frst;
   end Remove_Head;

   ----------------------
   -- Remove_From_Item --
   ----------------------

   procedure Remove_From_Item
     (This : in out Lists_Record;
      L    : List_Id;
      Itm  : Item_Id) is

      E : Entry_Id;
   begin
      E := This.Entry_From_Item (L, Itm);

      if E /= No_Entry_Id then
	 This.Remove (E);
      end if;
   end Remove_From_Item;

   ---------------------
   -- Entry_From_Item --
   ---------------------

   function Entry_From_Item
     (This : in Lists_Record;
      L    : List_Id;
      Itm  : Item_Id) return Entry_Id is

      E : Entry_Id;
   begin
      E := This.First_Entry (L);
      while E /= No_Entry_Id loop
         --  exit when Item (E) = Itm;
         if This.Item (E) = Itm then
            exit;
         end if;
         E := This.Next (E);
      end loop;

      return E;
   end Entry_From_Item;

   ---------------
   -- New_Entry --
   ---------------

   procedure New_Entry
     (This : in out Lists_Record;
      Itm  : Item_Id;
      E    : out Entry_Id) is
      
      Id : Entry_Id;
   begin
      Id := No_Entry_Id;

      for I in Entry_Id range Entry_Id'First + 1 .. Entry_Id'Last loop
	 if This.Entries_Table (I).Item = No_Item_Id then
	    Id := I;
	    This.Set_Item (Id, Itm);
	    exit;
	 end if;
      end loop;
      
      if Id /= No_Entry_Id then
	 This.Entries_Count := This.Entries_Count + 1;
      end if;
      E := Id;
   end New_Entry;

   ----------
   -- Next --
   ----------

   function Next
     (This : in Lists_Record;
      E    : Entry_Id) return Entry_Id is
   begin
      return This.Entries_Table (E).Next;
   end Next;

   --------------
   -- Previous --
   --------------

   function Previous
     (This : in Lists_Record;
      E    : Entry_Id) return Entry_Id is
   begin
      return This.Entries_Table (E).Previous;
   end Previous;

   ---------------
   -- List_Link --
   ---------------

   function List_Link
     (This : in Lists_Record;
      E    : Entry_Id) return List_Id is
   begin
      return This.Entries_Table (E).List_Link;
   end List_Link;

   ----------
   -- Item --
   ----------

   function Item 
     (This : in Lists_Record;
      E    : Entry_Id) return Item_Id is
   begin
      return This.Entries_Table (E).Item;
   end Item;

   --------------
   -- Set_Next --
   --------------

   procedure Set_Next
     (This : in out Lists_Record;
      E    : Entry_Id;
      Nxt  : Entry_Id) is
   begin
      This.Entries_Table (E).Next := Nxt;
   end Set_Next;

   ------------------
   -- Set_Previous --
   ------------------

   procedure Set_Previous
     (This : in out Lists_Record;
      E    : Entry_Id;
      Prev : Entry_Id) is
   begin
      This.Entries_Table (E).Previous := Prev;
   end Set_Previous;

   -------------------
   -- Set_List_Link --
   -------------------

   procedure Set_List_Link
     (This : in out Lists_Record;
      E    : Entry_Id;
      L    : List_Id) is
   begin
      This.Entries_Table (E).List_Link := L;
   end Set_List_Link;

   --------------
   -- Set_Item --
   --------------

   procedure Set_Item
     (This : in out Lists_Record;
      E    : Entry_Id;
      I    : Item_Id) is
   begin
      This.Entries_Table (E).Item := I;
   end Set_Item;

end Rx.Containers.Lists;
