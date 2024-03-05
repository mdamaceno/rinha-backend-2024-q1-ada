with GNATCOLL.SQL.Postgres; use GNATCOLL.SQL.Postgres;

package body DB_Connection is
   function Init return Database_Connection is
      DB_Descr : Database_Description;
   begin
      DB_Descr := Setup ("rinha2024",
                     User => "postgres",
                     Password => "postgres",
                     Host => "localhost",
                     Port => 5432);

      return DB_Descr.Build_Connection;
   end Init;
end DB_Connection;
