with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Models is
   type Kind_T is (c, d);

   type Ledger_M is record
      Id : Natural;
      Amount : Positive;
      Kind : Kind_T;
      Description : Unbounded_String;
      Account_Id : Positive;
      Created_At : Unbounded_String;
   end record;

   type Account_M is record
      Id : Positive;
      Name : Unbounded_String;
      Balance : Integer;
      Credit_Limit : Natural := 0;

      Error : Integer range 0..1 := 0;
   end record;

   type Transactions_T is array (Natural range <>) of Ledger_M;

   type Statement_M is record
      Balance : Integer;
      Credit_Limit : Natural;
      Transactions : Transactions_T (0 .. 10) := (others => <>);
   end record;
end Models;
