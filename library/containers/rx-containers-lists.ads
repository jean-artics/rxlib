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

--  This package provides facilities for manipulating lists of Entries that
--  point to user items. The lists is identified by a lList_Id which point
--  to an header containing the first and last netries in the list. Entries
--  are linked using the Next and Prev field of the entry. The entry point to
--  the user item which is identified by an Item_Id. An entry can be removed of
--  its lists, and then this entry becomes empty and can be reused later to
--  link an item in the list.

generic
   
   type List_Id is range <>;
   type Entry_Id is range <>;
   type Item_Id is range <>;
   
   No_Item_Id  : Item_Id;
   
package Rx.Containers.Lists is
   
   --  subtype List_Id is Integer range 0..100; 
   --  subtype Entry_Id is Integer range 0..200;
   --  subtype Item_Id is Integer;
   
   --  No_Item_Id  : Item_Id;
   
   
   No_List_Id  : constant List_Id  := List_Id'First;
   No_Entry_Id : constant Entry_Id := Entry_Id'First;
   
   type Lists_Record is tagged private;
   --  Record that encapsulates the list and entry infos.
   
   procedure Lists_Initialize  (This : in out Lists_Record);
   --  To initialize the package. Must be called before any call to the
   --  subprogram manipualting list.
   
   -- Header --
   ------------

   procedure New_List 
     (This : in out Lists_Record;
      Nl   : out List_Id);
   --  Creates a new empty item list. 

   function Empty_List 
     (This : in Lists_Record;
      L    : List_Id) return Boolean;
   
   function First_Entry 
     (This : in Lists_Record;
      L    : List_Id) return Entry_Id;
   pragma Inline (First_Entry);
   --  Return the first entry of list L
   
   function Last_Entry
     (This : in Lists_Record;
      L    : List_Id) return Entry_Id;
   pragma Inline (Last_Entry);
   --  Return the last entry of list L

   procedure Append
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id);
   --  Appends Entry at the end of node list To. Entrye must not be  already a
   --  member of a node list, 

   procedure Remove
     (This : in out Lists_Record;
      E    : Entry_Id);
   --  Removes Entry, which must be a entry that is a member of a list,
   --  The contents of Entry are not otherwise affected.

   procedure Remove_Head
     (This : in out Lists_Record;
      L    : List_Id;
      E    : out Entry_Id);
   --  Removes the head element of an entry list, and returns the node (whose
   --  contents are not otherwise affected) as the result. If the node list
   --  is empty, then No_Entry_Id is returned.

   procedure Remove_From_Item
     (This : in out Lists_Record;
      L    : List_Id;
      Itm  : Item_Id);
   --  Removes Entry wich points item. The contents of Entry are not otherwise
   --  affected.

   -----------
   -- Entry --
   -----------

   function Next
     (This : in Lists_Record;
      E    : Entry_Id) return Entry_Id;
   pragma Inline (Next);
   --  Return the entry following E in list to which E belongs
   
   function Previous
     (This : in Lists_Record;
      E    : Entry_Id) return Entry_Id;
   pragma Inline (Previous);
   --  Return the entry preceding E in list to which E belongs

   function List_Link
     (This : in Lists_Record;
      E    : Entry_Id) return List_Id;
   pragma Inline (List_Link);
   --  Return the list to which E belongs
   
   function Item
     (This : in Lists_Record;
      E    : Entry_Id) return Item_Id;
   pragma Inline (Item);
   --  Return the user Item pointed by Entry E

   procedure New_Entry
     (This : in out Lists_Record;
      Itm  : Item_Id;
      E    : out Entry_Id);
   --  Create a new entry pointing to user Item
   
   function Entry_From_Item
     (This : in Lists_Record;
      L    : List_Id;
      Itm  : Item_Id) return Entry_Id;
   --  Return the entry to which points to Item in the list L. If entry is
   --  empty, returns No_Entry_Id

   function No_Entry (E : Entry_Id) return Boolean;
   function No_List (L : List_Id) return Boolean;
   pragma Inline (No_Entry);
   pragma Inline (No_List);
   --  useless founction to the if Entry or List are epty

private

   --  Private Subprograms for manipulating List
   
   procedure Set_First
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id);
   --  The first entry of list L becomes E. 
   
   procedure Set_Last
     (This : in out Lists_Record;
      L    : List_Id;
      E    : Entry_Id);
   --  The last entry of list L becomes E. 

   procedure Set_Next
     (This : in out Lists_Record;
      E    : Entry_Id;
      Nxt  : Entry_Id);
   --  The entry following E is now Nxt

   procedure Set_Previous
     (This : in out Lists_Record;
      E    : Entry_Id;
      Prev : Entry_Id);
   --  The entry preceding E is now Prev

   --  Private Subprograms for manipulating Entry
   
   procedure Set_List_Link
     (This : in out Lists_Record;
      E    : Entry_Id;
      L    : List_Id);
   --  Entry E is in list L
   
   procedure Set_Item
     (This : in out Lists_Record;
      E    : Entry_Id;
      I    : Item_Id);
   --  Entry E point to the user item Item
   
   
   type Entry_Record is record
      List_Link : List_Id;
      --  The list where the enrty is linked. No_List_Id is there is the
      --  entry is not used
      
      Item : Item_Id;
      --  The user item
      
      Previous : Entry_Id;
      --  Previous ENtry in the list, No_Entry_Id if the entry is first entry 
      --  in the list
      
      Next : Entry_Id;
      --  Entry following the entry is the list. Set to No_Entry_Id if the
      --  entry is the last in the list
   end record;
   
   No_Entry_Record : constant Entry_Record :=
     Entry_Record'
     (List_Link => No_List_Id,
      Item      => No_Item_Id,
      Previous  => No_Entry_Id,
      Next      => No_Entry_Id);
   
   type List_Header is record
      First_Entry : Entry_Id;
      --  First Entry of the list
      
      Last_Entry  : Entry_Id;
      --  Last Entry of the list
   end record;

   No_List_Header : constant List_Header :=
     List_Header'
     (First_Entry => No_Entry_Id,
      Last_Entry  => No_Entry_Id);

   type Lists_Array is 
     array (List_Id range List_Id'First + 1 .. List_Id'Last) of List_Header;
   --  Table of list headers
   
   type Entries_Array is 
     array (Entry_Id range Entry_Id'First + 1 .. Entry_id'Last) of Entry_Record;
   --  Table of Entries
   
   type Lists_Record is tagged record
      Lists_Table   : Lists_Array;
      -- Table of list headers
      
      Entries_Table : Entries_Array; 
      --  Table of Entries
     
      Lists_Count   : List_Id;
      --  Point to the last entry allocated in list table
      
      Entries_Count : Entry_Id;
      --  Point to the last Entry allocated in the Entries table
   end record;
   
   No_Lists_Record : constant Lists_Record :=
     Lists_Record'
     (Lists_Table   => Lists_Array'(others => No_List_Header),
      Entries_Table => Entries_Array'(others => No_Entry_Record),
      Lists_Count   => No_List_Id,
      Entries_Count => No_Entry_Id);
   
--     pragma Inline_Always (Set_First);
--     pragma Inline_Always (Set_Last);
--     pragma Inline_Always (Set_Next);
--     pragma Inline_Always (Set_Previous);
--     pragma Inline_Always (Set_List_Link);
--     pragma Inline_Always (Set_Item);
     
end Rx.Containers.Lists;
