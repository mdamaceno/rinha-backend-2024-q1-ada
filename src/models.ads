with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Models is
   type Kind_T is (c, d);
   subtype Description_T is Unbounded_String;

   type Ledger_M is record
      Id : Natural;
      Amount : Positive;
      Kind : Kind_T;
      Description : Description_T;
      Account_Id : Positive;
   end record;
end Models;
