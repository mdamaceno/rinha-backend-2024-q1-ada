with Ada.Text_IO; use Ada.Text_IO;

with GNATCOLL.JSON; use GNATCOLL.JSON;

package body DTO is
   function Make_Transaction_From_JSON (Str : String) return Transaction is
      Data : constant JSON_Value := Read (Str);
      T    : Transaction;
      Invalid_Description_Length : exception;
   begin
      T.Description := Trim (Data.Get ("descricao"), Ada.Strings.Both);

      if Length (T.Description) = 0 or else Length (T.Description) > 10 then
         raise Invalid_Description_Length;
      end if;

      T.Amount := Data.Get ("valor");
      T.Kind := Data.Get ("tipo");

      return T;
   end Make_Transaction_From_JSON;
end DTO;
