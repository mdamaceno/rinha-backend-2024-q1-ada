with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Models is
   type Kind_T is (c, d);

   type Ledger_M is record
      Id : Natural;
      Amount : Positive;
      Kind : Kind_T;
      Description : Unbounded_String;
      Account_Id : Positive;
   end record;

   type Account_M is record
      Id : Positive;
      Name : Unbounded_String;
      Balance : Integer;
      Credit_Limit : Natural := 0;

      Error : Integer range 0..1 := 0;
   end record;
end Models;
