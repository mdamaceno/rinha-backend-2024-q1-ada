package body Helper.Account is
   function Extract_Account_ID (URI : String) return Accepted_ID is
      P_1 : constant String := "/transacoes";
      P_2 : constant String := "/extrato";
      Chunck_1   : constant String := URI (URI'First .. URI'First + 10);
      Chunck_2   : constant String := URI (URI'First + 10 .. URI'Last);

   begin
      if Chunck_1 (Chunck_1'First .. Chunck_1'First + 9) /= "/clientes/" then

         return 0;

      end if;

      if Chunck_2 (Chunck_2'First + 1 .. Chunck_2'Last) /= P_1 and then
         Chunck_2 (Chunck_2'First + 1 .. Chunck_2'Last) /= P_2 then

         return 0;

      end if;

      return Accepted_ID'Value (Chunck_2 (Chunck_2'First .. Chunck_2'First));

   exception
      when Constraint_Error =>

         return 0;

   end Extract_Account_ID;
end Helper.Account;
