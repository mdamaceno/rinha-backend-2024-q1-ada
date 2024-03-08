with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Environment_Variables;
with GNATCOLL.SQL.Postgres; use GNATCOLL.SQL.Postgres;
with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;
with GNATCOLL.SQL.Sessions;

package body DB_Connection is
   procedure Init is
      DB_Descr : Database_Description;
      DB_Host  : Unbounded_String;
   begin
      if Ada.Environment_Variables.Exists ("DB_HOST") then
         DB_Host := To_Unbounded_String
            (Ada.Environment_Variables.Value ("DB_HOST"));
      else
         DB_Host := To_Unbounded_String ("localhost");
      end if;

      DB_Descr := Setup ("rinha2024",
                     User => "postgres",
                     Password => "postgres",
                     Host => To_String (DB_Host),
                     Port => 5432);

      GNATCOLL.SQL.Sessions.Setup
         (Descr => DB_Descr, Max_Sessions => 50, Persist_Cascade => False);
   end Init;
end DB_Connection;
