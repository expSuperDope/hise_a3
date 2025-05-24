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
with CommandHandler;
with MyString_Instance;

procedure Main is
   use MyString_Instance;
   
   subtype Int32 is Calculator.Int32;
   subtype Result is calculator.Result;

   L:  Locker.Locker := (Number => 0, Locked => True);
   S: Lines.MyString;
   Sk:Stack.Stack_Instance;
   D: MemoryStore.Database;  
   
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

   Stack.Init(Sk);
   MemoryStore.Init(D);
   
   loop
      if(Locker.Is_Locked(L)) then
         Put("locked> ");             
      else 
         Put("unlocked> "); 
      end if;
      
      Lines.Get_Line(S);
      CommandHandler.Execute(L, Sk, D, S);
     
   end loop;
      
end Main;
