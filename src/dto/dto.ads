with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package DTO is
   subtype Kind_T is String (1 .. 1);
   subtype Description_T is Unbounded_String;

   type Transaction is record
      Amount : Positive;
      Kind : Kind_T;
      Description : Description_T;
   end record;

   function Make_Transaction_From_JSON (Str: String) return Transaction;
end DTO;
