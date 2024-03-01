with Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

with AWS.MIME; use AWS.MIME;
with AWS.Messages; use AWS.Messages;

with Response_Map;

package body Api_CB is

   subtype Accepted_ID is Integer range 0 .. 5;

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
         (Application_JSON, "{""message"":""Hello, world! GET""}");
   end Get;

   function Post (Request : AWS.Status.Data) return AWS.Response.Data is
      URI   : constant String := AWS.Status.URI (Request);

   begin
      return AWS.Response.Build
         (Application_JSON, Response_Map.Transaction_JSON);
   end Post;

   function Service (Request : AWS.Status.Data) return AWS.Response.Data is

      use type AWS.Status.Request_Method;
      URI : constant String := AWS.Status.URI (Request);
      ID  : constant Accepted_ID := Account_ID (URI);

   begin
      if ID = 0 then
         return AWS.Response.Build
            (Application_JSON, "{""error"":""Not found""}", S404);
      end if;

      if AWS.Status.Method (Request) = AWS.Status.GET then
         return Get (Request);
      elsif AWS.Status.Method (Request) = AWS.Status.POST then
         return Post (Request);
      else
         return AWS.Response.Build
            (Application_JSON, "{""error"":""Method Not Allowed""}", S405);
      end if;
   end Service;
end Api_CB;
