pragma SPARK_Mode (On);

with CommandHandler;
with MyStringTokeniser;
with MyString_Instance; use MyString_Instance;
with StringToInteger;
with PIN;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body CommandHandler with SPARK_Mode is

   procedure Execute(
      L  : in out Locker.Locker;
      Sk : in out Stack.Stack_Instance;
      D  : in out MemoryStore.Database;
      S  : Lines.MyString
   ) is
      T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
      NumTokens : Natural;
      subtype Int32 is Calculator.Int32;
      subtype Result is Calculator.Result;
   begin
      MyStringTokeniser.Tokenise(Lines.To_String(S), T, NumTokens);

      if NumTokens > 3 or NumTokens < 1 then
         Put_Line("You should enter 1-3 tokens!");
         return;
      end if;

      declare
         Token1 : String := Lines.To_String(Lines.Substring(S, T(1).Start, T(1).Start + T(1).Length - 1));
      begin
         if Token1 = "+" or else Token1 = "-" or else Token1 = "*" or else Token1 = "/" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 1 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               R : Result;
               A, B : Int32;
               Success : Boolean;
            begin
               Stack.Pop2(L, Sk, A, B, Success);
               if not Success then
                  Put_Line("Not enough number there!");
               else
                  if Token1 = "+" then
                     R := Calculator.Add(L, A, B);
                     Put_Line(Int32'Image(A) & " + " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                  elsif Token1 = "-" then
                     R := Calculator.Sub(L, A, B);
                     Put_Line(Int32'Image(A) & " - " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                  elsif Token1 = "*" then
                     R := Calculator.Mul(L, A, B);
                     Put_Line(Int32'Image(A) & " * " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                  else
                     R := Calculator.Div(L, A, B);
                     Put_Line(Int32'Image(A) & " / " & Int32'Image(B) & " = " & Int32'Image(R.Value));
                  end if;

                  if R.Success then
                     Stack.Push(L, Sk, R.Value, Success);
                     if not Success then
                        Put_Line("Write failed!");
                     end if;
                  else
                     Put_Line("Operation failed! Overflow or divide by zero.");
                     Stack.Push2(L, Sk, A, B, Success);
                     if not Success then
                        Put_Line("Write failed!");
                     end if;
                  end if;
               end if;
            end;

         elsif Token1 = "push1" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1)));
               Success : Boolean;
            begin
               Stack.Push(L, Sk, Int32(Token2), Success);
               if Success then
                  Put_Line("Push: " & Integer'Image(Token2));
               else
                  Put_Line("Full stack!");
               end if;
            end;

         elsif Token1 = "push2" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 3 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1)));
               Token3 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(3).Start, T(3).Start + T(3).Length - 1)));
               Success : Boolean;
            begin
               Stack.Push2(L, Sk, Int32(Token2), Int32(Token3), Success);
               if Success then
                  Put_Line("Push: " & Integer'Image(Token2) & " and " & Integer'Image(Token3));
               else
                  Put_Line("Full stack!");
               end if;
            end;

         elsif Token1 = "pop" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 1 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               A : Int32;
               Success : Boolean;
            begin
               Stack.Pop(L, Sk, A, Success);
               if Success then
                  Put_Line("Pop: " & Int32'Image(A));
               else
                  Put_Line("Empty stack!");
               end if;
            end;

         elsif Token1 = "storeTo" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1)));
               A : Int32;
               Success : Boolean;
            begin
               if Token2 < 1 or else Token2 > MemoryStore.Max_Locations then
                  Put_Line("Invalid memory location!");
               else
                  Stack.Pop(L, Sk, A, Success);
                  if not Success then
                     Put_Line("No elements in stack!");
                  else
                     LockMemory.Put(L, D, MemoryStore.Location_Index(Token2), A);
                     Put_Line("Stored successfully.");
                  end if;
               end if;
            end;

         elsif Token1 = "loadFrom" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1)));
               A : Int32;
               Success : Boolean;
            begin
               if Token2 < 1 or else Token2 > MemoryStore.Max_Locations then
                  Put_Line("Invalid memory location!");
               else
                  A := LockMemory.Get(L, D, MemoryStore.Location_Index(Token2));
                  Stack.Push(L, Sk, A, Success);
                  if Success then
                     Put_Line("Loaded: " & Int32'Image(A));
                  else
                     Put_Line("Full stack!");
                  end if;
               end if;
            end;

         elsif Token1 = "remove" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : Integer := StringToInteger.From_String(
                 Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1)));
            begin
               if Token2 < 1 or else Token2 > MemoryStore.Max_Locations then
                  Put_Line("Invalid memory location!");
               else
                  LockMemory.Remove(L, D, MemoryStore.Location_Index(Token2));
                  Put_Line("Removed.");
               end if;
            end;

         elsif Token1 = "list" then
            if Locker.Is_Locked(L) then
               Put_Line("Locked!");
               return;
            end if;

            LockMemory.Print(L, D);

         elsif Token1 = "lock" then
            if Locker.Is_Locked(L) then
               Put_Line("Already locked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : String := Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1));
            begin
               if Token2'Length /= 4 or else (for some I in Token2'Range => Token2(I) not in '0' .. '9') then
                  Put_Line("Invalid PIN.");
               else
                  Locker.Reset_PWD(L, PIN.From_String(Token2));
                  Put_Line("Locked with new PIN.");
               end if;
            end;

         elsif Token1 = "unlock" then
            if not Locker.Is_Locked(L) then
               Put_Line("Already unlocked!");
               return;
            end if;

            if NumTokens /= 2 then
               Put_Line("Count of tokens is not correct!");
               return;
            end if;

            declare
               Token2 : String := Lines.To_String(Lines.Substring(S, T(2).Start, T(2).Start + T(2).Length - 1));
            begin
               if Token2'Length /= 4 or else (for some I in Token2'Range => Token2(I) not in '0' .. '9') then
                  Put_Line("Invalid PIN.");
               else
                  Locker.Try_Unlock(L, PIN.From_String(Token2));
                  Put_Line("Unlock attempt made.");
               end if;
            end;

         elsif Token1 = "quit" then
            Put_Line("Exiting...");
            return;

         else
            Put_Line("Unknown command: " & Token1);
         end if;
      end;
   end Execute;

end CommandHandler;
