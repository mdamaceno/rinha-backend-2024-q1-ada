with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;
with Models;

package Repository is

   function Create_Transaction
      (DB_Conn : Database_Connection; Ledger : Models.Ledger_M)
         return Models.Account_M;

   function Get_Account
      (DB_Conn : Database_Connection; Account_Id : Positive)
         return Models.Account_M;

   function Get_Last_Transactions (
      DB_Conn    : Database_Connection;
      Account_Id : Positive;
      Limit      : Positive := 10
   ) return Models.Statement_M;

end Repository;
