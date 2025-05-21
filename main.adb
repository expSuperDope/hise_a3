pragma SPARK_Mode (On);

with MyCommandLine;
with MyString;
with MyStringTokeniser;
with StringToInteger;
with PIN;
with MemoryStore;

with Calculator;
with Stack;
with Locker;
with LockMemory;

with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Long_Long_Integer_Text_IO;
with Ada.Command_Line;


procedure Main is
   
   subtype Int32 is Calculator.Int32;
   subtype Result is calculator.Result;

   Success : Boolean := False;
   
   L: Locker.Locker;
   R : Result;
   
   S:Stack.Stack_Instance;
   
   A,B,C: Int32;
   
   D: MemoryStore.Database;
   D_Index1 : MemoryStore.Location_Index:= 1;
   D_Index2 : MemoryStore.Location_Index:= 10;
   
   Line : String (1 .. 200);
   Last : Natural;
       
begin
 
   if MyCommandLine.Argument_Count /= 1 then
     Put_Line("Please provide a single 4-digits PIN.");
     return;
   end if;
   
   declare
      PIN_Str : constant String := MyCommandLine.Argument(1);
   begin
      if PIN_Str'Length /= 4 or else
        (for some I in PIN_Str'Range => PIN_Str(I) not in '0' .. '9') then
         Put_Line("Please provide a single 4-digits PIN.");
         return;
      else 
         Locker.Init(L,PIN.From_String(PIN_Str));
      end if;
   end;

   Stack.Init(S);
   MemoryStore.Init(D);
   
   loop
      if(Locker.Is_Locked(L)) then
         Put("locked> ");             
      else 
         Put("unlocked> "); 
      end if;
      
      Get_Line(Line, Last);     

      if Line(1 .. Last) = "quit" then
         exit;
      end if;

      Put_Line("You entered: " & Line(1 .. Last));
   end loop;


   
   
   R := Calculator.Add(L, Int32'Last, 1);
   R := Calculator.Sub(L, Int32'First, 1);
   R := Calculator.Mul(L, Int32'Last, 2);
   R := Calculator.Div(L,1,0);
   
   Put_Line("============================");
   R := Calculator.Add(L,1,1);
   R := Calculator.Sub(L,1,1);
   R := Calculator.Mul(L,2,1);
   R := Calculator.Div(L,2,2);
   
   Put_Line("============================");
   Stack.Pop(L,S,A,Success);
   Stack.Pop2(L,S,A,B,Success);
   Stack.Push(L,S,1,Success);
   Stack.Push2(L,S,A,B,Success);
   Stack.Push(L,S,1,Success);
   Stack.Push(L,S,1,Success);
   Put_Line("+++++++++++++++++++++++++++++");
   
   
   LockMemory.Print(L,D);
   C:= LockMemory.Get(L,D,D_Index1);
   C:= LockMemory.Get(L,D,D_Index2);
   LockMemory.Put(L,D,D_Index1,2);
   LockMemory.Print(L,D);
   LockMemory.Put(L,D,D_Index2,7);
   LockMemory.Print(L,D);
   C:= LockMemory.Get(L,D,D_Index1);
   Put (Integer (C)); 
   LockMemory.Remove(L,D,D_Index1);
   C:= LockMemory.Get(L,D,D_Index1);
   Put (Integer (C)); 
   LockMemory.Print(L,D);
   
   
   
   Put_Line("============================");
   Locker.Try_Unlock(L,PIN.From_String("4321"));
   Locker.Try_Unlock(L,PIN.From_String("1234"));
   
   R := Calculator.Add(L, Int32'Last, 1);
   R := Calculator.Sub(L, Int32'First, 1);
   R := Calculator.Mul(L, Int32'Last, 2);
   R := Calculator.Div(L,1,0);
   
   Put_Line("============================");
   R := Calculator.Add(L,1,1);
   R := Calculator.Sub(L,1,1);
   R := Calculator.Mul(L,2,1);
   R := Calculator.Div(L,2,2);
   
   Put_Line("============================");
   Stack.Pop(L,S,A,Success);
   Stack.Pop2(L,S,A,B,Success);
   Stack.Push(L,S,1,Success);
   Stack.Push2(L,S,A,B,Success);
   Stack.Push(L,S,1,Success);
   Stack.Push(L,S,1,Success);
   Put_Line("+++++++++++++++++++++++++++++");
   Put_Line("0:");
   LockMemory.Print(L,D);
   
   C:= LockMemory.Get(L,D,D_Index1);
   C:= LockMemory.Get(L,D,D_Index2);
   LockMemory.Put(L,D,D_Index1,2);
   Put_Line("1:");
   LockMemory.Print(L,D);
   LockMemory.Put(L,D,D_Index2,7);
   Put_Line("2:");
   LockMemory.Print(L,D);
   C:= LockMemory.Get(L,D,D_Index1);
   Put_Line("3:");
   Put (Integer (C)); 
   Put_Line("");
   LockMemory.Remove(L,D,D_Index1);
   LockMemory.Remove(L,D,D_Index1);
   Put_Line("4:");
   C:= LockMemory.Get(L,D,D_Index1);
   Put(Integer (C));
   Put_Line("");
   Put_Line("5:");
   LockMemory.Print(L,D);
  
   Put_Line("============================");
   Locker.Reset_PWD(L,PIN.From_String("4321"));
   Locker.Reset_PWD(L,PIN.From_String("1234"));
   Locker.Try_Unlock(L,PIN.From_String("4321"));
   Locker.Try_Unlock(L,PIN.From_String("4321"));
      
end Main;
