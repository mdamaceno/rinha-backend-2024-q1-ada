with Ada.Streams;

package body Helper.Request is
   function Get_Body_Content
      (Request : AWS.Status.Data) return String_Access is
         Binary_Size   : constant Ada.Streams.Stream_Element_Offset := AWS.Status.Binary_Size (Request);
         Stream_Buffer : Ada.Streams.Stream_Element_Array (1 .. Binary_Size);
         Stream_Index  : Ada.Streams.Stream_Element_Offset := 1;
         Str_Index     : Integer := 1;
   begin
      return Body_Content : constant String_Access := new String (1 .. Integer (Binary_Size)) do
         while True loop
            AWS.Status.Read_Body (Request, Stream_Buffer, Stream_Index);

            for I in 1 .. Stream_Index loop
               Body_Content (Str_Index) := Character'Val (Stream_Buffer (I));
               Str_Index := Str_Index + 1;
            end loop;

            exit when Integer (Stream_Index) < 1;
         end loop;
      end return;
   end Get_Body_Content;
end Helper.Request;
