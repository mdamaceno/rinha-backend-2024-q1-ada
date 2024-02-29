with Ada.Text_IO;
with AWS.Server;
with AWS.Server.Log;
with AWS.Log;

with Api_CB;

procedure Rinha_2024_Q1_Ada is

   WS : AWS.Server.HTTP;

begin
   Ada.Text_IO.Put_Line ("AWS " & AWS.Version);
   Ada.Text_IO.Put_Line ("Enter 'q' key to exit...");

   AWS.Server.Start
     (WS, "Rinha de Backend Q1 2024",
      Callback => Api_CB.Service'Access,
      Port => 8080);

   AWS.Server.Log.Start (WS, Split_Mode => AWS.Log.Daily);

   AWS.Server.Wait (AWS.Server.Q_Key_Pressed);

   AWS.Server.Shutdown (WS);
end Rinha_2024_Q1_Ada;
