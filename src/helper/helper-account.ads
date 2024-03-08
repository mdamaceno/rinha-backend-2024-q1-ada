package Helper.Account is
   subtype Accepted_ID is Integer range 0 .. 5;

   function Extract_Account_ID (URI : String) return Accepted_ID;
end Helper.Account;
