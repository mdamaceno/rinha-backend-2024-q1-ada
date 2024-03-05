with GNATCOLL.SQL; use GNATCOLL.SQL;
package Database_Names is
   pragma Style_Checks (Off);
   TC_Public_Accounts : aliased constant String := "public.accounts";
   Ta_Public_Accounts : constant Cst_String_Access := TC_Public_Accounts'Access;
   TC_Public_Ledgers : aliased constant String := "public.ledgers";
   Ta_Public_Ledgers : constant Cst_String_Access := TC_Public_Ledgers'Access;

   NC_Account_Id : aliased constant String := "account_id";
   N_Account_Id : constant Cst_String_Access := NC_account_id'Access;
   NC_Amount : aliased constant String := "amount";
   N_Amount : constant Cst_String_Access := NC_amount'Access;
   NC_Balance : aliased constant String := "balance";
   N_Balance : constant Cst_String_Access := NC_balance'Access;
   NC_Created_At : aliased constant String := "created_at";
   N_Created_At : constant Cst_String_Access := NC_created_at'Access;
   NC_Credit_Limit : aliased constant String := "credit_limit";
   N_Credit_Limit : constant Cst_String_Access := NC_credit_limit'Access;
   NC_Description : aliased constant String := "description";
   N_Description : constant Cst_String_Access := NC_description'Access;
   NC_Id : aliased constant String := "id";
   N_Id : constant Cst_String_Access := NC_id'Access;
   NC_Kind : aliased constant String := "kind";
   N_Kind : constant Cst_String_Access := NC_kind'Access;
   NC_Name : aliased constant String := """name""";
   N_Name : constant Cst_String_Access := NC_name'Access;
   NC_Updated_At : aliased constant String := "updated_at";
   N_Updated_At : constant Cst_String_Access := NC_updated_at'Access;
end Database_Names;
