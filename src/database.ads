with GNATCOLL.SQL; use GNATCOLL.SQL;
pragma Warnings (Off, "no entities of * are referenced");
pragma Warnings (Off, "use clause for package * has no effect");
with GNATCOLL.SQL_Fields; use GNATCOLL.SQL_Fields;
pragma Warnings (On, "no entities of * are referenced");
pragma Warnings (On, "use clause for package * has no effect");
with Database_Names; use Database_Names;
package Database is
   pragma Style_Checks (Off);
   pragma Elaborate_Body;

   ------------
   -- Public --
   ------------

   package Public is

      type T_Abstract_Public_Accounts
         (Instance : Cst_String_Access;
          Index    : Integer)
      is abstract new SQL_Table (Ta_Public_Accounts, Instance, Index) with
      record
         Balance : SQL_Field_Integer (Ta_Public_Accounts, Instance, N_Balance, Index);
         Created_At : SQL_Field_Time (Ta_Public_Accounts, Instance, N_Created_At, Index);
         Credit_Limit : SQL_Field_Integer (Ta_Public_Accounts, Instance, N_Credit_Limit, Index);
         Id : SQL_Field_Integer (Ta_Public_Accounts, Instance, N_Id, Index);
         Name : SQL_Field_Text (Ta_Public_Accounts, Instance, N_Name, Index);
         Updated_At : SQL_Field_Time (Ta_Public_Accounts, Instance, N_Updated_At, Index);
      end record;

      type T_Public_Accounts (Instance : Cst_String_Access)
         is new T_Abstract_Public_Accounts (Instance, -1) with null record;
      --  To use named aliases of the table in a query
      --  Use Instance=>null to use the default name.

      type T_Numbered_Public_Accounts (Index : Integer)
         is new T_Abstract_Public_Accounts (null, Index) with null record;
      --  To use aliases in the form name1, name2,...

      type T_Abstract_Public_Ledgers
         (Instance : Cst_String_Access;
          Index    : Integer)
      is abstract new SQL_Table (Ta_Public_Ledgers, Instance, Index) with
      record
         Account_Id : SQL_Field_Integer (Ta_Public_Ledgers, Instance, N_Account_Id, Index);
         Amount : SQL_Field_Integer (Ta_Public_Ledgers, Instance, N_Amount, Index);
         Created_At : SQL_Field_Time (Ta_Public_Ledgers, Instance, N_Created_At, Index);
         Description : SQL_Field_Text (Ta_Public_Ledgers, Instance, N_Description, Index);
         Id : SQL_Field_Integer (Ta_Public_Ledgers, Instance, N_Id, Index);
         Kind : SQL_Field_Text (Ta_Public_Ledgers, Instance, N_Kind, Index);
      end record;

      type T_Public_Ledgers (Instance : Cst_String_Access)
         is new T_Abstract_Public_Ledgers (Instance, -1) with null record;
      --  To use named aliases of the table in a query
      --  Use Instance=>null to use the default name.

      type T_Numbered_Public_Ledgers (Index : Integer)
         is new T_Abstract_Public_Ledgers (null, Index) with null record;
      --  To use aliases in the form name1, name2,...

      function FK (Self : T_Public_Ledgers'Class; Foreign : T_Public_Accounts'Class) return SQL_Criteria;
      Accounts : T_Public_Accounts (null);
      Ledgers : T_Public_Ledgers (null);
   end Public;
end Database;
