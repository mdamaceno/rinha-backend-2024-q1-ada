with AWS.MIME; use AWS.MIME;
with AWS.Messages; use AWS.Messages;

package body Api_CB is

   function Get (Request : AWS.Status.Data) return AWS.Response.Data is

   begin
      return AWS.Response.Build
         (Application_JSON, "{""message"":""Hello, world! GET""}");
   end Get;

   function Post (Request : AWS.Status.Data) return AWS.Response.Data is
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
