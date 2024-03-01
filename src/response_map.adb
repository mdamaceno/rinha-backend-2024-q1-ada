with Ada.Text_IO;
with GNATCOLL.JSON;

package body Response_Map is
   use Ada.Text_IO;
   use GNATCOLL.JSON;

   function Transaction_JSON(
      Balance : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String is

      Transaction : constant JSON_Value := Create_Object;

   begin
      Transaction.Set_Field (Field_Name => "limite", Field => Balance);
      Transaction.Set_Field (Field_Name => "saldo", Field => Credit_Limit);

      return Transaction.Write;
   end Transaction_JSON;
end Response_Map;
