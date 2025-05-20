pragma SPARK_Mode(On);

package body Stack with SPARK_Mode is
   
   procedure Init(S : out Stack_Instance) is
   begin
      for I in Stack_Index loop
         S.Data(I) := 0;
      end loop;
      S.Top_Index := 0;
   end Init;
   
   procedure Push(S : in out Stack_Instance; A : Int32; Success : in out Boolean) is
   begin
      if S.Top_Index + 1 <= Max_Capacity then
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := A;
         Success := True;
      else
         Success := False;
      end if;
   end Push;

   procedure Push2(S : in out Stack_Instance; A, B : Int32; Success : in out Boolean) is
   begin
      if S.Top_Index + 2 <= Max_Capacity then
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := A;
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := B;
         Success := True;
      else
         Success := False;
      end if;
   end Push2;

   procedure Pop(S : in out Stack_Instance; A : out Int32; Success : in out Boolean) is
   begin
      if S.Top_Index - 1 >= 0 then
         A := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         Success := True;
      else
         Success := False;
      end if;
   end Pop;

   procedure Pop2(S : in out Stack_Instance; A, B : out Int32; Success : in out Boolean) is
   begin
      if S.Top_Index - 2 >= 0 then
         B := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         A := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         Success := True;
      else
         Success := False;
      end if;
   end Pop2;

end Stack;
