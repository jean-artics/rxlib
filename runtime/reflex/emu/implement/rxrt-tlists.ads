------------------------------------------------------------------------------
--                                                                          --
--                         REFLEX RUN TIME COMPONENTS                       --
--                                                                          --
--                               N L I S T S                                --
--                                                                          --
--                                 S p e c                                  --
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
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- Reflex is developed  by the Artics                                       --
--                                                                          --
------------------------------------------------------------------------------

--  This package provides facilities for manipulating lists of nodes (see
--  package Atree for format and implementation of tree nodes). The Link field
--  of the nodes is used as the forward pointer for these lists. See also
--  package Elists which provides another form of lists that are not threaded
--  through the nodes (and therefore allow nodes to be on multiple lists).

with System;

with Rxrt.Params; use Rxrt.Params;

package Rxrt.Tlists is
   
   --  A node list is a list of nodes in a special format that means that
   --  nodes can be on at most one such list. For each node list, a list
   --  header is allocated in the lists table, and a List_Id value references
   --  this header, which may be used to access the nodes in the list using
   --  the set of routines that define this interface.

   --  Note: node lists can contain either nodes or entities (extended nodes)
   --  or a mixture of nodes and extended nodes.

   function In_Same_List (T1, T2 : Task_Id) return Boolean;
   pragma Inline (In_Same_List);
   --  Equivalent to List_Containing (N1) = List_Containing (N2)

   function Last_List_Id return Task_List_Id;
   pragma Inline (Last_List_Id);
   --  Returns Id of last allocated list header

   function Lists_Address return System.Address;
   pragma Inline (Lists_Address);
   --  Return address of Lists table (used in Back_End for Gigi call)

   function Num_Lists return Natural;
   pragma Inline (Num_Lists);
   --  Number of currently allocated lists

   function New_List return Task_List_Id;
   --  Creates a new empty node list. Typically this is used to initialize
   --  a field in some other node which points to a node list where the list
   --  is then subsequently filled in using Append calls.
   
   function New_List
     (Tsk : Task_Id) return Task_List_Id;
   --  Build a new list initially containing the given node

   function First (List : Task_List_Id) return Task_Id;
   pragma Inline (First);
   --  Obtains the first element of the given node list or, if the node list
   --  has no items or is equal to No_List, then Empty is returned.

   function Last (List : Task_List_Id) return Task_Id;
   pragma Inline (Last);
   --  Obtains the last element of the given node list or, if the node list
   --  has no items, then Empty is returned. It is an error to call Last with
   --  a Node_Id or No_List. (No_List is not considered to be the same as an
   --  empty node list).

   function List_Length (List : Task_List_Id) return Natural;
   pragma Inline (List_Length);
   --  Returns number of items in the given list. It is an error to call
   --  this function with No_List (No_List is not considered to be the same
   --  as an empty list).

   function Next (Tsk : Task_Id) return Task_Id;
   pragma Inline (Next);
   --  This function returns the next node on a node list, or Empty if Node is
   --  the last element of the node list. The argument must be a member of a
   --  node list.

   procedure Next (Tsk : in out Task_Id);
   pragma Inline (Next);
   --  Equivalent to Node := Next (Node);

   function Prev (Tsk : Task_Id) return Task_Id;
   pragma Inline (Prev);
   --  This function returns the previous node on a node list, or Empty
   --  if Node is the first element of the node list. The argument must be
   --  a member of a node list. Note: the implementation does maintain back
   --  pointers, so this function executes quickly in constant time.

   function Pick (List : Task_List_Id; Index : Positive) return Task_Id;
   --  Given a list, picks out the Index'th entry (1 = first entry). The
   --  caller must ensure that Index is in range.

   procedure Prev (Tsk : in out Task_Id);
   pragma Inline (Prev);
   --  Equivalent to Node := Prev (Node);

   function Is_Empty_List (List : Task_List_Id) return Boolean;
   pragma Inline (Is_Empty_List);
   --  This function determines if a given list id references a node list that
   --  contains no items. No_List as an argument returns True.

   function Is_Non_Empty_List (List : Task_List_Id) return Boolean;
   pragma Inline (Is_Non_Empty_List);
   --  This function determines if a given list id references a node list that
   --  contains at least one item. No_List as an argument returns False.

   procedure Append (Tsk : Task_Id; To : Task_List_Id);
   --  Appends Node at the end of node list To. Node must be a non-empty node
   --  that is not already a member of a node list, and To must be a
   --  node list. An attempt to append an error node is ignored without
   --  complaint and the list is unchanged.

   procedure Append_To (To : Task_List_Id; Tsk : Task_Id);
   pragma Inline (Append_To);
   --  Like Append, but arguments are the other way round

   procedure Append_List (List : Task_List_Id; To : Task_List_Id);
   --  Appends node list List to the end of node list To. On return,
   --  List is reset to be empty.

   procedure Append_List_To (To : Task_List_Id; List : Task_List_Id);
   pragma Inline (Append_List_To);
   --  Like Append_List, but arguments are the other way round

   procedure Insert_After
     (After : Task_Id;
      Tsk   : Task_Id);
   --  Insert Node, which must be a non-empty node that is not already a
   --  member of a node list, immediately past node After, which must be a
   --  node that is currently a member of a node list. An attempt to insert
   --  an error node is ignored without complaint (and the list is unchanged).

   procedure Insert_List_After
     (After : Task_Id;
      List  : Task_List_Id);
   --  Inserts the entire contents of node list List immediately after node
   --  After, which must be a member of a node list. On return, the node list
   --  List is reset to be the empty node list.

   procedure Insert_Before
     (Before : Task_Id;
      Tsk    : Task_Id);
   --  Insert Node, which must be a non-empty node that is not already a
   --  member of a node list, immediately before Before, which must be a node
   --  that is currently a member of a node list. An attempt to insert an
   --  error node is ignored without complaint (and the list is unchanged).

   procedure Insert_List_Before
     (Before : Task_Id;
      List   : Task_List_Id);
   --  Inserts the entire contents of node list List immediately before node
   --  Before, which must be a member of a node list. On return, the node list
   --  List is reset to be the empty node list.

   procedure Prepend
     (Tsk : Task_Id;
      To  : Task_List_Id);
   --  Prepends Node at the start of node list To. Node must be a non-empty
   --  node that is not already a member of a node list, and To must be a
   --  node list. An attempt to prepend an error node is ignored without
   --  complaint and the list is unchanged.

   procedure Prepend_To
     (To  : Task_List_Id;
      Tsk : Task_Id);
   pragma Inline (Prepend_To);
   --  Like Prepend, but arguments are the other way round

   procedure Prepend_List
     (List : Task_List_Id;
      To   : Task_List_Id);
   --  Prepends node list List to the start of node list To. On return,
   --  List is reset to be empty.

   procedure Prepend_List_To
     (To   : Task_List_Id;
      List : Task_List_Id);
   pragma Inline (Prepend_List_To);
   --  Like Prepend_List, but arguments are the other way round

   procedure Remove (Tsk : Task_Id);
   --  Removes Node, which must be a node that is a member of a node list,
   --  from this node list. The contents of Node are not otherwise affected.

   function Remove_Head (List : Task_List_Id) return Task_Id;
   --  Removes the head element of a node list, and returns the node (whose
   --  contents are not otherwise affected) as the result. If the node list
   --  is empty, then Empty is returned.

   function Remove_Next (Tsk : Task_Id) return Task_Id;
   --  Removes the item immediately following the given node, and returns it
   --  as the result. If Node is the last element of the list, then Empty is
   --  returned. Node must be a member of a list. Unlike Remove, Remove_Next
   --  is fast and does not involve any list traversal.

   procedure Initialize;
   --  Called at the start of compilation of each new main source file to
   --  initialize the allocation of the list table. Note that Initialize
   --  must not be called if Tree_Read is used.

   function No (List : Task_List_Id) return Boolean;
   pragma Inline (No);
   --  Tests given Id for equality with No_List. This allows notations like
   --  "if No (Statements)" as opposed to "if Statements = No_List".

   function Present (List : Task_List_Id) return Boolean;
   pragma Inline (Present);
   --  Tests given Id for inequality with No_List. This allows notations like
   --  "if Present (Statements)" as opposed to "if Statements /= No_List".

   procedure Allocate_List_Tables (Tsk : Task_Id);
   --  Called when nodes table is expanded to include node N. This call
   --  makes sure that list structures internal to Nlists are adjusted
   --  appropriately to reflect this increase in the size of the nodes table.

   function Next_Task_Address return System.Address;
   function Prev_Task_Address return System.Address;
   --  These functions return the addresses of the Next_Node and Prev_Node
   --  tables (used in Back_End for Gigi).

end Rxrt.Tlists;
