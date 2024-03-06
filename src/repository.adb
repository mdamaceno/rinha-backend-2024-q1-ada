with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with GNATCOLL.SQL;  use GNATCOLL.SQL;
with Database; use Database;

package body Repository is
   Select_Accounts_Stmt : Prepared_Statement := Prepare
      ("SELECT id, credit_limit, balance FROM accounts", Use_Cache => False, Index_By => Field_Index'First);

   function Create_Transaction (DB_Conn : Database_Connection; Ledger : Models.Ledger_M) return Models.Account_M is
      Q          : SQL_Query;
      Ledgers_T  : Database.Public.T_Public_Ledgers := Database.Public.Ledgers;
      DB         : Database_Connection := DB_Conn;

      Insufficient_Funds : exception;

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

   function Get_Account (DB_Conn : Database_Connection; Account_Id : Positive) return Models.Account_M is
      CI         : Direct_Cursor;
      DB         : Database_Connection := DB_Conn;
      Account    : Models.Account_M;
   begin
      CI.Fetch (DB, Select_Accounts_Stmt);
      CI.Find (Account_Id);

      Put_Line (CI.Value (0));
      Put_Line (CI.Value (1));
      Put_Line (CI.Value (2));

      Account.Id := Positive'Value (CI.Value (0));
      Account.Credit_Limit := Integer'Value (CI.Value (1));
      Account.Balance := Integer'Value (CI.Value (2));

      return Account;
   end Get_Account;
end Repository;
