package Response_Map is
   function Transaction_JSON(
      Balance : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String;

   function Statement_JSON(
      Total : Integer := 0;
      Credit_Limit : Integer := 0
   ) return String;
end Response_Map;
