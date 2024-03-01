with Ada.Text_IO;
with AWS.Server;
with AWS.Server.Log;
with AWS.Log;

with Api_CB;

procedure Rinha_2024_Q1_Ada is

   WS : AWS.Server.HTTP;

begin
   Ada.Text_IO.Put_Line ("AWS " & AWS.Version);

   AWS.Server.Start
     (WS, "Rinha de Backend Q1 2024",
      Callback => Api_CB.Service'Access,
      Port => 8080);

   AWS.Server.Log.Start (WS, Split_Mode => AWS.Log.Daily);

   loop
      null;
   end loop;

end Rinha_2024_Q1_Ada;
