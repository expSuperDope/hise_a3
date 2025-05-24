pragma SPARK_Mode(On);

package body Stack with SPARK_Mode is
   
   procedure Init(S : out Stack_Instance) is
   begin
      for I in Stack_Index loop
         S.Data(I) := 0;
      end loop;
      S.Top_Index := 1;
   end Init;
   
   procedure Push(L:Locker.Locker; S : in out Stack_Instance; A : Int32; Success : out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Success:= False;
         return;
      end if;
      
      if S.Top_Index <= Max_Capacity then
         S.Data(S.Top_Index) := A;
         S.Top_Index := S.Top_Index + 1;
         Success := True;
      else
         Success := False;
      end if;
   end Push;

   procedure Push2(L:Locker.Locker; S : in out Stack_Instance; A, B : Int32; Success : out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Success:= False;
         return;
      end if;
      
      if S.Top_Index + 1 <= Max_Capacity then
         S.Data(S.Top_Index) := A;
         S.Top_Index := S.Top_Index + 1;
         S.Data(S.Top_Index) := B;         
         S.Top_Index := S.Top_Index + 1;
         Success := True;
      else
         Success := False;
      end if;
   end Push2;

   procedure Pop(L:Locker.Locker; S : in out Stack_Instance; A : out Int32; Success : out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         Success:= False;
         A:= 0;
         return;
      end if;
      
      if S.Top_Index - 1 >= 1 then
         S.Top_Index := S.Top_Index - 1;
         A := S.Data(S.Top_Index);
         Success := True;
      else
         A:= 0;
         Success := False;
      end if;
   end Pop;

   procedure Pop2(L:Locker.Locker; S : in out Stack_Instance; A, B : out Int32; Success : out Boolean) is
   begin
      if Locker.Is_Locked(L) then
         Success:= False;
         A:= 0;
         B:= 0;
         return;
      end if;
      
      if S.Top_Index - 2 >= 1 then
         S.Top_Index := S.Top_Index - 1;
         B := S.Data(S.Top_Index);
         S.Top_Index := S.Top_Index - 1;
         A := S.Data(S.Top_Index);
         Success := True;
      else
         A:= 0;
         B:= 0;
         Success := False;
      end if;
   end Pop2;

end Stack;
