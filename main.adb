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
       
begin
   
   Stack.Init(S);
   MemoryStore.Init(D);
   
   Locker.Init(L,PIN.From_String("1234"));
   
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
   
--       Stack.Init(s);
   
--       if Ada.Command_Line.Argument_Count /= 3 then
--          Put_Line("Usage: ./main <op> <a> <b>");
--          return;
--       end if;
--   
--       Op_Code := Integer'Value(Ada.Command_Line.Argument(1));
--       A       := Int32'Value(Ada.Command_Line.Argument(2));
--       B       := Int32'Value(Ada.Command_Line.Argument(3));
--   
--       case Op_Code is
--         when 1 =>
--           Stack.Push(S,A,Success);
--           if Success then
--              Put_Line("Result: Push Successfully");
--           else
--              Put_Line("Not enough space");
--           end if;
--         when 2 =>
--           Stack.Push2(S,A,B,Success);
--           if Success then
--              Put_Line("Result: Push2 Successfully");
--           else
--              Put_Line("Not enough space");
--           end if;
--         when 3 =>
--           Stack.Pop(S,A,Success);
--           if Success then
--              Put_Line("Result: Pop Successfully");
--           else
--                 Put_Line("Not enough number");
--           end if;
--         when 4 =>
--           Stack.Pop2(S,A,B,Success);
--           if Success then
--              Put_Line("Result: Pop2 Successfully");
--           else
--                 Put_Line("Not enough number");
--           end if;
--         when others =>
--            Put_Line("Invalid operation code.");
--            return;
--    end case;
      
end Main;
