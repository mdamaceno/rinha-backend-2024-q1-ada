with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with GNATCOLL.SQL;  use GNATCOLL.SQL;
with Database;

package body Repository is
   Select_Accounts_Stmt : constant Prepared_Statement := Prepare
      ("SELECT id, credit_limit, balance FROM accounts", Use_Cache => False, Index_By => Field_Index'First);

   function Create_Transaction (DB_Conn : Database_Connection; Ledger : Models.Ledger_M) return Models.Account_M is
      Q          : SQL_Query;
      Ledgers_T  : constant Database.Public.T_Public_Ledgers := Database.Public.Ledgers;
      DB         : constant Database_Connection := DB_Conn;

   begin
      Q := SQL_Insert
         (
            Values => (Ledgers_T.Amount = Ledger.Amount) &
                      (Ledgers_T.Description = To_String (Ledger.Description)) &
                      (Ledgers_T.Kind = To_Lower (Models.Kind_T'Image (Ledger.Kind))) &
                      (Ledgers_T.Account_Id = Ledger.Account_Id)
         );

      Execute (DB, Q);

      declare
         Account : Models.Account_M;
      begin
         Account := Get_Account (DB, Ledger.Account_Id);

         if Account.Balance < -(Account.Credit_Limit) then
            Account.Error := 1;

            Rollback (DB);
         else
            Commit (DB);
         end if;

         return Account;
      end;
   end Create_Transaction;

   function Get_Account (
      DB_Conn    : Database_Connection;
      Account_Id : Positive
   ) return Models.Account_M is
      CI         : Direct_Cursor;
      DB         : constant Database_Connection := DB_Conn;
      Account    : Models.Account_M;
   begin
      CI.Fetch (DB, Select_Accounts_Stmt);
      CI.Find (Account_Id);

      Account.Id := Positive'Value (CI.Value (0));
      Account.Credit_Limit := Integer'Value (CI.Value (1));
      Account.Balance := Integer'Value (CI.Value (2));

      return Account;
   end Get_Account;

   function Get_Last_Transactions
      (
         DB_Conn    : Database_Connection;
         Account_Id : Positive;
         Limit      : Positive := 10
      ) return Models.Statement_M is

      Q          : SQL_Query;
      DB         : constant Database_Connection := DB_Conn;
      Ledgers_T  : constant Database.Public.T_Public_Ledgers :=
         Database.Public.Ledgers;
      Account    : Models.Account_M;
      Ledger     : Models.Ledger_M;
      Statement  : Models.Statement_M;

   begin
      Account := Get_Account (DB, Account_Id);

      Statement.Balance := Account.Balance;
      Statement.Credit_Limit := Account.Credit_Limit;

      Q := SQL_Select
         (
            Fields => Ledgers_T.Amount &
                      Ledgers_T.Kind &
                      Ledgers_T.Description &
                      Ledgers_T.Created_At,
            From => Ledgers_T,
            Where => Ledgers_T.Account_Id = Account.Id,
            Order_By => Desc (Ledgers_T.Created_At),
            Limit => Limit
         );

      declare
         R : Forward_Cursor;
         Counter    : Natural := 0;
      begin
         R.Fetch (Connection => DB, Query => Q);

         while Has_Row (R) loop
            Ledger.Amount := Integer_Value (R, 0);
            Ledger.Kind := Models.Kind_T'Value (Value (R, 1));
            Ledger.Description := To_Unbounded_String (Value (R, 2));
            Ledger.Created_At := To_Unbounded_String (Value (R, 3));

            Statement.Transactions (Counter) := Ledger;

            Counter := Counter + 1;
            Next (R);
         end loop;

         return Statement;
      end;
   end Get_Last_Transactions;
end Repository;
