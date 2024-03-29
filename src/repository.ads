with Models;

package Repository is

   procedure Create_Transaction
      (Ledger : Models.Ledger_M; Account : out Models.Account_M);

   function Get_Account
      (Account_Id : Positive)
         return Models.Account_M;

   function Get_Last_Transactions (
      Account_Id : Positive;
      Limit      : Positive := 10
   ) return Models.Statement_M;

end Repository;
