with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;
with Models;

package Repository is
   function Create_Transaction (DB_Conn : Database_Connection; Ledger : Models.Ledger_M) return Models.Ledger_M;
   function Last_Inserted (DB_Conn : Database_Connection) return Models.Ledger_M;
end Repository;
