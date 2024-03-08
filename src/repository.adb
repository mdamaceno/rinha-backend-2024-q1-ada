with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with GNATCOLL.SQL;  use GNATCOLL.SQL;
with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;
with GNATCOLL.SQL.Sessions; use GNATCOLL.SQL.Sessions;
with Database;

package body Repository is
   Select_Accounts_Stmt : constant Prepared_Statement := Prepare
      ("SELECT id, credit_limit, balance FROM accounts", Use_Cache => False, Index_By => Field_Index'First);

   procedure Create_Transaction (Ledger : Models.Ledger_M; Account : out Models.Account_M) is
      Q          : SQL_Query;
      Ledgers_T  : constant Database.Public.T_Public_Ledgers := Database.Public.Ledgers;
      Session : constant Session_Type := Get_New_Session;
      DB      : Database_Connection;

   begin
      Q := SQL_Insert
         (
            Values => (Ledgers_T.Amount = Ledger.Amount) &
                      (Ledgers_T.Description = To_String (Ledger.Description)) &
                      (Ledgers_T.Kind = To_Lower (Models.Kind_T'Image (Ledger.Kind))) &
                      (Ledgers_T.Account_Id = Ledger.Account_Id)
         );

      DB := Session.DB;

      Execute (DB, Q);

      if Success (DB) then
         Commit (DB);
         Account := Get_Account (Ledger.Account_Id);
      else
         Rollback (DB);
         Account.Error := 1;
      end if;
   end Create_Transaction;

   function Get_Account (
      Account_Id : Positive
   ) return Models.Account_M is
      CI         : Direct_Cursor;
      DB         : Database_Connection;
      Account    : Models.Account_M;
      Session : constant Session_Type := Get_New_Session;
   begin
      DB := Session.DB;
      CI.Fetch (DB, Select_Accounts_Stmt);
      CI.Find (Account_Id);

      Account.Id := Positive'Value (CI.Value (0));
      Account.Credit_Limit := Integer'Value (CI.Value (1));
      Account.Balance := Integer'Value (CI.Value (2));

      return Account;
   end Get_Account;

   function Get_Last_Transactions
      (
         Account_Id : Positive;
         Limit      : Positive := 10
      ) return Models.Statement_M is

      Q          : SQL_Query;
      DB         : Database_Connection;
      Ledgers_T  : constant Database.Public.T_Public_Ledgers :=
         Database.Public.Ledgers;
      Account    : Models.Account_M;
      Ledger     : Models.Ledger_M;
      Statement  : Models.Statement_M;
      Session : constant Session_Type := Get_New_Session;

   begin
      DB := Session.DB;
      Account := Get_Account (Account_Id);

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
