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
   package Lines is new MyString (Max_MyString_Length => 2048);
   
   subtype Int32 is Calculator.Int32;
   subtype Result is calculator.Result;

   L: Locker.Locker;
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
      declare
         T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
         NumTokens : Natural;
      begin
         MyStringTokeniser.Tokenise(Lines.To_String(S),T,NumTokens);
         
         if NumTokens > 3 or NumTokens < 1 then
            Put_Line("You should enter 1-3 tokens!");
            goto Next_Iteration;
         end if;
         
         declare
            Token1: String := Lines.To_String(Lines.Substring(S,T(1).Start,T(1).Start+T(1).Length-1));
         begin
            
            if Token1 = "+" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  R:Result;
                  A,B:Int32:= 0;
                  Success: Boolean := False;
               begin
                  Stack.Pop2(L,Sk,A,B,Success);
                  if(not Success) then
                     Put_Line("Not enough number there!");
                  else
                     R:= Calculator.Add(L,A,B);
                     if(R.Success) then
                        Stack.Push(L,Sk,Int32(R.Value),Success);
                        Put_Line(Int32'Image(A) & " + " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                     else
                        Put_Line("Overflow!Ignore this operation!");
                        Stack.Push2(L,Sk,A,B,Success);
                     end if;
                  end if;
               end;

            elsif Token1 = "-" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  R:Result;
                  A,B:Int32:= 0;
                  Success: Boolean := False;
               begin
                  Stack.Pop2(L,Sk,A,B,Success);
                  if(not Success) then
                     Put_Line("Not enough number there!");
                  else
                     R:= Calculator.Sub(L,A,B);
                     if(R.Success) then
                        Stack.Push(L,Sk,Int32(R.Value),Success);
                        Put_Line(Int32'Image(A) & " - " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                     else
                        Put_Line("Overflow!Ignore this operation!");
                        Stack.Push2(L,Sk,A,B,Success);
                     end if;
                  end if;
               end;
               
            elsif Token1 = "*" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  R:Result;
                  A,B:Int32:= 0;
                  Success: Boolean := False;
               begin
                  Stack.Pop2(L,Sk,A,B,Success);
                  if(not Success) then
                     Put_Line("Not enough number there!");
                  else
                     R:= Calculator.Mul(L,A,B);
                     if(R.Success) then
                        Stack.Push(L,Sk,Int32(R.Value),Success);
                        Put_Line(Int32'Image(A) & " * " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                     else
                        Put_Line("Overflow!Ignore this operation!");
                        Stack.Push2(L,Sk,A,B,Success);
                     end if;
                  end if;
               end;
               
            elsif Token1 = "/" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  R:Result;
                  A,B:Int32:= 0;
                  Success: Boolean := False;
               begin
                  Stack.Pop2(L,Sk,A,B,Success);
                  if(not Success) then
                     Put_Line("Not enough number there!");
                  else
                     R:= Calculator.Div(L,A,B);
                     if(R.Success) then
                        Stack.Push(L,Sk,Int32(R.Value),Success);
                        Put_Line(Int32'Image(A) & " / " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                     else
                        Put_Line("Div 0!Ignore this operation!");
                        Stack.Push2(L,Sk,A,B,Success);
                     end if;
                  end if;
               end;

            elsif Token1 = "push1" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
                 
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: Integer := StringToInteger.From_String(
                                     Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                  Success: Boolean := False;
               begin
                  if (Token2 > Integer(Int32'Last) or else Token2 < Integer(Int32'First)) then
                     Put_Line("Invalid argument(s):Number is out of bounds!");
                  else
                     Stack.Push(L,Sk,Int32(Token2),Success);
                     Put_Line("Push: " & Integer'Image(Token2));
                  end if;
               end;

            elsif Token1 = "push2" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 3) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: Integer := StringToInteger.From_String(
                                     Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                  Token3: Integer := StringToInteger.From_String(
                                                                 Lines.To_String(Lines.Substring(S,T(3).Start,T(3).Start+T(3).Length-1)));
                  Success: Boolean := False;
               begin
                  if (Token2 > Integer(Int32'Last) or else Token2 < Integer(Int32'First)
                     or else Token3 > Integer(Int32'Last) or else Token3 < Integer(Int32'First)) then
                     Put_Line("Invalid argument(s):Number is out of bounds!");
                  else
                     Stack.Push2(L,Sk,Int32(Token2),Int32(Token3),Success);
                     Put_Line("Push: " & Integer'Image(Token2) & " and " & Integer'Image(Token3));
                  end if;
               end;

            elsif Token1 = "pop" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  A: Int32:= 0;
                  Success: Boolean := False;
               begin 
                  Stack.Pop(L,Sk,A,Success);
                  Put_Line("Pop: " & Int32'Image(A));
               end;
               
               
            elsif Token1 = "loadFrom" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: Integer := StringToInteger.From_String(
                                     Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                  A:Int32:= 0;
                  Success: Boolean := False;
               begin
                  if (Token2 > MemoryStore.Max_Locations or else Token2 < 1) then
                     Put_Line("Invalid argument(s):Location is out of bound!");
                  else
                     A:= LockMemory.Get(L,D,MemoryStore.Location_Index(Token2));
                     Stack.Push(L,Sk,A,Success);
                     if(Success) then
                        Put_Line("Load " & Int32'Image(A) & " successfully!");
                     else
                        Put_Line("Load failed");
                     end if;
                     
                  end if;
               end;
     
            elsif Token1 = "storeTo" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: Integer := StringToInteger.From_String(
                                     Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                  A:Int32:= 0;
                  Success: Boolean := False;
               begin
                  if (Token2 > MemoryStore.Max_Locations or else Token2 < 1) then
                     Put_Line("Invalid argument(s):Location is out of bound!");
                  else
                     Stack.Pop(L,Sk,A,Success);
                     if(not Success) then
                        Put_Line("No elements in stack!");
                     else
                        LockMemory.Put(L,D,MemoryStore.Location_Index(Token2),MemoryStore.Int32(A));
                        Stack.Push(L,Sk,A,Success);
                        Put_Line("Store successfully!");
                     end if;
                  end if;
               end;
               
            elsif Token1 = "remove" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: Integer := StringToInteger.From_String(
                                     Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
               begin
                  if (Token2 > MemoryStore.Max_Locations or else Token2 < 1) then
                     Put_Line("Invalid argument(s):Location is out of bound!");
                  else
                     LockMemory.Remove(L,D, MemoryStore.Location_Index(Token2));
                     Put_Line("Remove successfully!");
                  end if;
               end;
               
            elsif Token1 = "list" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 1) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               LockMemory.Print(L,D);
               
            elsif Token1 = "lock" then
               if (Locker.Is_Locked(L)) then
                  Put_Line("Already locked!");
                  goto Next_Iteration;
               end if;
               
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: String := Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1));
               begin
                  if Token2'Length /= 4 or else
                    (for some I in Token2'Range => Token2(I) not in '0' .. '9') then
                     Put_Line("Invalid argument(s).");
                  else
                     Locker.Reset_PWD(L,PIN.From_String(Token2));
                  end if;
               end;
               
            elsif Token1 = "unlock" then
               if (not Locker.Is_Locked(L)) then
                  Put_Line("Already unlocked!");
                  goto Next_Iteration;
               end if;
               
               
               if(NumTokens /= 2) then
                  Put_Line("Count of tokens is not correct!");
                  goto Next_Iteration;
               end if;
               
               declare
                  Token2: String := Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1));
               begin
                  if Token2'Length /= 4 or else
                    (for some I in Token2'Range => Token2(I) not in '0' .. '9') then
                     Put_Line("Invalid argument(s).");
                  else
                     Locker.Try_Unlock(L,PIN.From_String(Token2));
                  end if;
               end;
               
            elsif Token1 = "quit" then
               Put_Line("Exiting...");
               return;

            else
               Put_Line("Unknown command: " & Token1);
            end if;
            
         end;
      end;
      
   <<Next_Iteration>>
   end loop;
      
end Main;
