package body Database is
   pragma Style_Checks (Off);
   package body Public is

      function FK (Self : T_Public_Ledgers'Class; Foreign : T_Public_Accounts'Class) return SQL_Criteria is
      begin
         return Self.Account_Id = Foreign.Id;
      end FK;
   end Public;
end Database;
