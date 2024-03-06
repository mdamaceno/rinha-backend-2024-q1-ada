with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

with AWS.MIME;
with AWS.Messages;

with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;

with Helper.Request;
with Response_Map;
with DTO;
with Repository;
with DB_Connection;
with Models;

package body Api_CB is

   subtype Accepted_ID is Integer range 0 .. 5;

   DB_Conn : Database_Connection := DB_Connection.Init;

   function Account_ID (URI : String) return Accepted_ID;

   function Account_ID (URI : String) return Accepted_ID is
      P_1 : constant String := "/transacoes";
      P_2 : constant String := "/extrato";
      F   : constant String := URI (URI'First + 10 .. URI'Last);
      Idx : Natural;

   begin
      if Ada.Strings.Fixed.Index (F, P_1) > 0 then
         Idx := Ada.Strings.Fixed.Index (F, P_1);
         return Integer'Value (Ada.Strings.Fixed.Delete (F, Idx, Idx + P_1'Length - 1));
      end if;

      Idx := Ada.Strings.Fixed.Index (F, P_2);
      return Integer'Value (Ada.Strings.Fixed.Delete (F, Idx, Idx + P_2'Length - 1));

   exception
      when Constraint_Error =>
         return 0;
   end Account_ID;

   function Get (Request : AWS.Status.Data) return AWS.Response.Data is

   begin
      return AWS.Response.Build
         (AWS.MIME.Application_JSON, Response_Map.Statement_JSON
            (Total => 100, Credit_Limit => 1000)
         );
   end Get;

   function Post (Request : AWS.Status.Data) return AWS.Response.Data is
      URI      : constant String := AWS.Status.URI (Request);
      Req_Body : constant String_Access := Helper.Request.Get_Body_Content (Request);
      Str      : constant String := Req_Body.all;
      T        : DTO.Transaction := DTO.Make_Transaction_From_JSON (Str);
      Ledger   : Models.Ledger_M;

   begin
      Ledger.Account_Id := Account_ID (URI);
      Ledger.Amount := T.Amount;
      Ledger.Description := T.Description;
      Ledger.Kind := Models.Kind_T'Value (T.Kind);

      declare
         Result : Models.Account_M;
      begin
         Result := Repository.Create_Transaction(DB_Conn, Ledger);

         if Result.Error = 1 then
            return AWS.Response.Build
               (AWS.MIME.Application_JSON, "{""error"":""Exceeded credit limits""}", AWS.Messages.S422);
         end if;

         return AWS.Response.Build
            (AWS.MIME.Application_JSON, Response_Map.Transaction_JSON
               (Result.Balance, Result.Credit_Limit)
            );
      end;
   end Post;

   function Service (Request : AWS.Status.Data) return AWS.Response.Data is

      use type AWS.Status.Request_Method;
      URI : constant String := AWS.Status.URI (Request);
      ID  : constant Accepted_ID := Account_ID (URI);

   begin
      if ID = 0 then
         return AWS.Response.Build
            (AWS.MIME.Application_JSON, "{""error"":""Not found""}", AWS.Messages.S404);
      end if;

      if AWS.Status.Method (Request) = AWS.Status.GET then
         return Get (Request);
      elsif AWS.Status.Method (Request) = AWS.Status.POST then
         return Post (Request);
      else
         return AWS.Response.Build
            (AWS.MIME.Application_JSON, "{""error"":""Method Not Allowed""}", AWS.Messages.S405);
      end if;
   end Service;

end Api_CB;
