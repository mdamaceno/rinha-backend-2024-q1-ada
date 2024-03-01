package Response_Map is
   function Transaction_JSON(
      Amount : Integer := 0;
      Kind   : String := "";
      Description : String := ""
   ) return String;
end Response_Map;
