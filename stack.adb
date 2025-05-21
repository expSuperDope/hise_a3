pragma SPARK_Mode(On);

package body Stack with SPARK_Mode is
   
   procedure Init(S : out Stack_Instance) is
   begin
      for I in Stack_Index loop
         S.Data(I) := 0;
      end loop;
      S.Top_Index := 0;
   end Init;
   
   procedure Push(L:Locker.Locker; S : in out Stack_Instance; A : Int32; Success : in out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         Success:= False;
         return;
      end if;
      
      if S.Top_Index + 1 <= Max_Capacity then
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := A;
         Success := True;
         Put_Line("Push successfully");
      else
         Success := False;
         Put_Line("Push failed");
      end if;
   end Push;

   procedure Push2(L:Locker.Locker; S : in out Stack_Instance; A, B : Int32; Success : in out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         Success:= False;
         return;
      end if;
      
      if S.Top_Index + 2 <= Max_Capacity then
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := A;
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := B;
         Success := True;
         Put_Line("Push successfully");
      else
         Success := False;
         Put_Line("Push failed");
      end if;
   end Push2;

   procedure Pop(L:Locker.Locker; S : in out Stack_Instance; A : out Int32; Success : in out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         Success:= False;
         A:= 0;
         return;
      end if;
      
      if S.Top_Index - 1 >= 0 then
         A := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         Success := True;
         Put_Line("Pop successfully");
      else
         Success := False;
         Put_Line("Pop failed");
      end if;
   end Pop;

   procedure Pop2(L:Locker.Locker; S : in out Stack_Instance; A, B : out Int32; Success : in out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         Success:= False;
         A:= 0;
         B:= 0;
         return;
      end if;
      
      if S.Top_Index - 2 >= 0 then
         B := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         A := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         Success := True;
         Put_Line("Pop successfully");
      else
         Success := False;
         Put_Line("Pop failed");
      end if;
   end Pop2;

end Stack;
