pragma SPARK_Mode (On);

with MyCommandLine;
with MyString;
with MyStringTokeniser;
with StringToInteger;
with PIN;
with MemoryStore;

with Calculator;
with Stack;

with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Long_Long_Integer_Text_IO;
with Ada.Command_Line;


procedure Main is
   
   subtype Int32 is Calculator.Int32;
   subtype Result is calculator.Result;

   Op_Code : Integer;
   A, B : Int32;
   S    : Stack.Stack_Instance;
   Success : Boolean := False;
       
begin
   
     Stack.Init(s);
   
     if Ada.Command_Line.Argument_Count /= 3 then
        Put_Line("Usage: ./main <op> <a> <b>");
        return;
     end if;
 
     Op_Code := Integer'Value(Ada.Command_Line.Argument(1));
     A       := Int32'Value(Ada.Command_Line.Argument(2));
     B       := Int32'Value(Ada.Command_Line.Argument(3));
 
     case Op_Code is
       when 1 =>
         Stack.Push(S,A,Success);
         if Success then
            Put_Line("Result: Push Successfully");
         else
            Put_Line("Not enough space");
         end if;
       when 2 =>
         Stack.Push2(S,A,B,Success);
         if Success then
            Put_Line("Result: Push2 Successfully");
         else
            Put_Line("Not enough space");
         end if;
       when 3 =>
         Stack.Pop(S,A,Success);
         if Success then
            Put_Line("Result: Pop Successfully");
         else
               Put_Line("Not enough number");
         end if;
       when 4 =>
         Stack.Pop2(S,A,B,Success);
         if Success then
            Put_Line("Result: Pop2 Successfully");
         else
               Put_Line("Not enough number");
         end if;
       when others =>
          Put_Line("Invalid operation code.");
          return;
  end case;
      
end Main;
