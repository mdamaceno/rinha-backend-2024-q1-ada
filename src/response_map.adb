with Ada.Text_IO;
with GNATCOLL.JSON;

package body Response_Map is
   use Ada.Text_IO;
   use GNATCOLL.JSON;

   function Transaction_JSON(
      Amount : Integer := 0;
      Kind   : String := "";
      Description : String := ""
   ) return String is

      Transaction : constant JSON_Value := Create_Object;

   begin
      Transaction.Set_Field (Field_Name => "valor", Field => Amount);
      Transaction.Set_Field (Field_Name => "tipo", Field => Kind);
      Transaction.Set_Field (Field_Name => "descricao", Field => Description);

      return Transaction.Write;
   end Transaction_JSON;
end Response_Map;
