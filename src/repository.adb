with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with GNATCOLL.SQL;  use GNATCOLL.SQL;
with Database; use Database;

package body Repository is
   Last_Inserted_Stmt : Prepared_Statement := Prepare
      ("SELECT id, amount, kind, description, account_id FROM ledgers ORDER BY id DESC LIMIT 1");

   function Create_Transaction (DB_Conn : Database_Connection; Ledger : Models.Ledger_M) return Models.Ledger_M is
      Q          : SQL_Query;
      Ledgers_T  : Database.Public.T_Public_Ledgers := Database.Public.Ledgers;
      DB         : Database_Connection := DB_Conn;

   begin
      Q := SQL_Insert
         (
            Values => (Ledgers_T.Amount = Ledger.Amount) &
                      (Ledgers_T.Description = To_String (Ledger.Description)) &
                      (Ledgers_T.Kind = To_Lower (Models.Kind_T'Image (Ledger.Kind))) &
                      (Ledgers_T.Account_Id = Ledger.Account_Id)
         );

      Execute (DB, Q);

      Commit (DB);

      return Last_Inserted (DB);
   end Create_Transaction;

   function Last_Inserted (DB_Conn : Database_Connection) return Models.Ledger_M is
      CI         : Direct_Cursor;
      DB         : Database_Connection := DB_Conn;
      Ledger     : Models.Ledger_M;
   begin
      CI.Fetch (DB, Last_Inserted_Stmt);
      CI.First;

      Ledger.Id := Positive'Value (CI.Value (0));
      Ledger.Amount := Positive'Value (CI.Value (1));
      Ledger.Kind := Models.Kind_T'Value (To_Upper (CI.Value (2)));
      Ledger.Description := To_Unbounded_String (CI.Value (3));
      Ledger.Account_Id := Integer'Value (CI.Value (4));

      Put_Line ("Last_Inserted: " & Ledger.Id'Image & " " & Ledger.Amount'Image & " " & Models.Kind_T'Image (Ledger.Kind) & " " & To_String (Ledger.Description) & " " & Ledger.Account_Id'Image);

      return Ledger;
   end Last_Inserted;
end Repository;
