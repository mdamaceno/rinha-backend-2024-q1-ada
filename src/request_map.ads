with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with AWS.Status;

package Request_Map is

   function Get_Body_Content (Request : AWS.Status.Data) return String_Access;

end Request_Map;
