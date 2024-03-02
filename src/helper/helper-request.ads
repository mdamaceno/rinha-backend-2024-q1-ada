with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with AWS.Status;

package Helper.Request is

   function Get_Body_Content (Request : AWS.Status.Data) return String_Access;

end Helper.Request;
