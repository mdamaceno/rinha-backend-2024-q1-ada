with AWS.Status;
with AWS.Response;

with Helper.Account;

package Api_CB is

   function Get (ID : Helper.Account.Accepted_ID) return AWS.Response.Data;
   function Post (Request : AWS.Status.Data; ID : Helper.Account.Accepted_ID) return AWS.Response.Data;
   function Service (Request : AWS.Status.Data) return AWS.Response.Data;

end Api_CB;
