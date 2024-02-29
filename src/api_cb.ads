with AWS.Status;
with AWS.Response;

package Api_CB is

   function Get (Request : AWS.Status.Data) return AWS.Response.Data;
   function Post (Request : AWS.Status.Data) return AWS.Response.Data;
   function Service (Request : AWS.Status.Data) return AWS.Response.Data;

end Api_CB;
