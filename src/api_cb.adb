with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with AWS.MIME;
with AWS.Messages;

with Helper.Request;
with Response_Map;
with DTO;
with Repository;
with Models;

package body Api_CB is
   subtype Accepted_ID is Integer range 0 .. 5;

   function Account_ID (URI : String) return Accepted_ID;

   function Account_ID (URI : String) return Accepted_ID is
      P_1 : constant String := "/transacoes";
      P_2 : constant String := "/extrato";
      F   : constant String := URI (URI'First + 10 .. URI'Last);
      Idx : Natural;

   begin
      if URI (URI'First .. URI'First + 9) /= "/clientes/" then
         return 0;
      end if;

      if Ada.Strings.Fixed.Index (F, P_1) > 0 then
         Idx := Ada.Strings.Fixed.Index (F, P_1);
         return Integer'Value
            (Ada.Strings.Fixed.Delete (F, Idx, Idx + P_1'Length - 1));
      end if;

      Idx := Ada.Strings.Fixed.Index (F, P_2);
      return Integer'Value
         (Ada.Strings.Fixed.Delete (F, Idx, Idx + P_2'Length - 1));

   exception
      when Constraint_Error =>
         return 0;
   end Account_ID;

   function Get (Request : AWS.Status.Data) return AWS.Response.Data is
      URI       : constant String := AWS.Status.URI (Request);
      Statement : Models.Statement_M;
   begin
      Statement := Repository.Get_Last_Transactions (Account_ID (URI));

      return AWS.Response.Build
         (AWS.MIME.Application_JSON, Response_Map.Statement_JSON (Statement));
   end Get;

   function Post (Request : AWS.Status.Data) return AWS.Response.Data is
      URI      : constant String := AWS.Status.URI (Request);
      Req_Body : constant String_Access :=
         Helper.Request.Get_Body_Content (Request);
      Str      : constant String := Req_Body.all;
      T        : constant DTO.Transaction :=
         DTO.Make_Transaction_From_JSON (Str);
      Ledger   : Models.Ledger_M;
      Account  : Models.Account_M;

   begin
      if T.Error > 0 then
         return AWS.Response.Build
            (AWS.MIME.Application_JSON,
            "{""error"":""Invalid JSON""}", AWS.Messages.S422);
      end if;

      Ledger.Account_Id := Account_ID (URI);
      Ledger.Amount := T.Amount;
      Ledger.Description := T.Description;
      Ledger.Kind := Models.Kind_T'Value (T.Kind);

      Account := Repository.Get_Account (Ledger.Account_Id);
      Repository.Create_Transaction (Ledger, Account);

      if Account.Error = 1 then
         return AWS.Response.Build
            (AWS.MIME.Application_JSON,
            "{""error"":""Exceeded credit limits""}", AWS.Messages.S422);
      end if;

      return AWS.Response.Build
         (AWS.MIME.Application_JSON, Response_Map.Transaction_JSON
            (Account.Balance, Account.Credit_Limit)
         );
   end Post;

   function Service (Request : AWS.Status.Data) return AWS.Response.Data is

      use type AWS.Status.Request_Method;
      URI : constant String := AWS.Status.URI (Request);
      ID  : constant Accepted_ID := Account_ID (URI);

   begin
      if ID = 0 then
         return AWS.Response.Build
            (AWS.MIME.Application_JSON,
            "{""error"":""Not found""}", AWS.Messages.S404);
      end if;

      if AWS.Status.Method (Request) = AWS.Status.GET then
         return Get (Request);
      elsif AWS.Status.Method (Request) = AWS.Status.POST then
         return Post (Request);
      else
         return AWS.Response.Build
            (AWS.MIME.Application_JSON,
            "{""error"":""Method Not Allowed""}", AWS.Messages.S405);
      end if;
   end Service;

end Api_CB;
