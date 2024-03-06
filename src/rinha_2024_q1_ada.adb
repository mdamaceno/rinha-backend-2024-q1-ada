with Ada.Text_IO;
with AWS.Server;
with AWS.Server.Log;
with AWS.Log;
with AWS.Config;
with AWS.Config.Set;

with Api_CB;

procedure Rinha_2024_Q1_Ada is

   WS : AWS.Server.HTTP;
   AWS_Config      : AWS.Config.Object := AWS.Config.Default_Config;

begin
   AWS.Config.Set.Reuse_Address (AWS_Config, True);
   AWS.Config.Set.Server_Port (AWS_Config, 9999);

   Ada.Text_IO.Put_Line ("AWS " & AWS.Version);
   AWS.Server.Start (WS, Callback => Api_CB.Service'Access, Config => AWS_Config);

   AWS.Server.Log.Start (WS, Split_Mode => AWS.Log.Daily);

   loop
      null;
   end loop;

end Rinha_2024_Q1_Ada;
