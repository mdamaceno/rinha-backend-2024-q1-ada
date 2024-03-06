with Models;

package Response_Map is
   function Transaction_JSON
      (Balance : Integer := 0; Credit_Limit : Integer := 0) return String;

   function Statement_JSON (Statement : Models.Statement_M) return String;
end Response_Map;
