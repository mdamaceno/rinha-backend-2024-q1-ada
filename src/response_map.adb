with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Calendar;
with GNATCOLL.JSON;
with Util.Dates.RFC7231;

package body Response_Map is
   use GNATCOLL.JSON;

   function Transaction_JSON (
      Balance : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String is

      Transaction : constant JSON_Value := Create_Object;

   begin
      Transaction.Set_Field (Field_Name => "limite", Field => Credit_Limit);
      Transaction.Set_Field (Field_Name => "saldo", Field => Balance);

      return Transaction.Write;
   end Transaction_JSON;

   function Statement_JSON (Statement : Models.Statement_M) return String is

      Now  : constant Ada.Calendar.Time := Ada.Calendar.Clock;
      S    : constant String := Util.Dates.RFC7231.Image (Now);

      Account_Summary : constant JSON_Value := Create_Object;
      Balance : constant JSON_Value := Create_Object;
   begin
      Balance.Set_Field (Field_Name => "total", Field => Statement.Balance);
      Balance.Set_Field (Field_Name => "data_extrato", Field => S);
      Balance.Set_Field (
         Field_Name => "limite",
         Field => Statement.Credit_Limit
      );

      Account_Summary.Set_Field (Field_Name => "saldo", Field => Balance);

      declare
         Transactions : JSON_Array;
         T : JSON_Value;
      begin
         for I in Statement.Transactions'Range loop
            if To_String (Statement.Transactions (I).Created_At) /= "" then
               T := Create_Object;

               T.Set_Field
                  (
                     Field_Name => "valor",
                     Field => Statement.Transactions (I).Amount
                  );
               T.Set_Field
                  (
                     Field_Name => "tipo",
                     Field => To_Lower
                        (Models.Kind_T'Image (Statement.Transactions (I).Kind))
                  );
               T.Set_Field
                  (
                     Field_Name => "descricao",
                     Field => Statement.Transactions (I).Description
                  );
               T.Set_Field
                  (
                     Field_Name => "realizada_em",
                     Field => Statement.Transactions (I).Created_At
                  );

               Append (Transactions, T);
            end if;
         end loop;

         if Length (Transactions) > 0 then
            Account_Summary.Set_Field
               (Field_Name => "ultimas_transacoes", Field => Transactions);
         else
            Account_Summary.Set_Field
               (Field_Name => "ultimas_transacoes", Field => Empty_Array);
         end if;

         return Account_Summary.Write;
      end;
   end Statement_JSON;
end Response_Map;
