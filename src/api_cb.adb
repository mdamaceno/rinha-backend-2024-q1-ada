with Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Fixed;

with AWS.MIME; use AWS.MIME;
with AWS.Messages; use AWS.Messages;

package body Api_CB is
   P_1 : constant String := "/transacoes";
   P_2 : constant String := "/extrato";

   function Account_ID (URI : String; Pattern : String) return String;

   function Account_ID (URI : String; Pattern : String) return String is
      F   : constant String := URI (URI'First + 10 .. URI'Last);
      Idx : Natural;

   begin
      Idx := Ada.Strings.Fixed.Index (F, Pattern);
      return Ada.Strings.Fixed.Delete (F, Idx, Idx + Pattern'Length - 1);
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
         (Application_JSON, "{""message"":""Hello, world! POST""}");
   end Post;

   function Service (Request : AWS.Status.Data) return AWS.Response.Data is

      use type AWS.Status.Request_Method;

   begin
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
