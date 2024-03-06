with Ada.Calendar;
with GNATCOLL.JSON;
with Util.Dates.RFC7231;

package body Response_Map is
   use GNATCOLL.JSON;

   function Transaction_JSON(
      Balance : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String is

      Transaction : constant JSON_Value := Create_Object;

   begin
      Transaction.Set_Field (Field_Name => "limite", Field => Credit_Limit);
      Transaction.Set_Field (Field_Name => "saldo", Field => Balance);

      return Transaction.Write;
   end Transaction_JSON;

   function Statement_JSON(
      Total : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String is
      Now  : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      S    : constant String := Util.Dates.RFC7231.Image (Now);

      Account_Summary : constant JSON_Value := Create_Object;
      Balance : constant JSON_Value := Create_Object;
      Transactions : JSON_Array := Empty_Array;
   begin
      Balance.Set_Field (Field_Name => "total", Field => Total);
      Balance.Set_Field (Field_Name => "data_extrato", Field => S);
      Balance.Set_Field (Field_Name => "limite", Field => Credit_Limit);

      Account_Summary.Set_Field (Field_Name => "saldo", Field => Balance);
      Account_Summary.Set_Field (Field_Name => "ultimas_transacoes", Field => Transactions);

      return Account_Summary.Write;
   end Statement_JSON;
end Response_Map;
