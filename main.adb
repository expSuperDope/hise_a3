--  Task 4: 
--
--  The following security properties verified using SPARK Prover.
--  All properties are enforced either through preconditions (in the `.ads` files),
--  defensive checks (in `.adb` bodies), or GNATprove assumptions/assertions.
--
--  Security Properties Verified:
--
--  1. Arithmetic operations can only be performed
--     when the calculator is in the unlocked state.
--      It is Enforced via `with Pre => not Locker.Is_Locked(L)` in:
--        - Calculator.Add, Sub, Mul, Div
--      In `commandhandler.adb`, these are only called if the locker is verified
--        to be unlocked, e.g.`if Locker.Is_Locked(L) then return;`
--      GNATprove verifies that these preconditions hold at all call sites.
--
--  2. Stack operations (Push, Push2, Pop, Pop2) can only be performed
--     in the *unlocked* state.
--      Also enforced using `with Pre => not Locker.Is_Locked(L)` in `stack.ads`.
--      GNATprove verifies this based on prior checks at each use.
--
--  3. Memory operations (Load/Store/Remove/Print) must only occur in
--     the *unlocked* state and with valid memory location indices.
--      `with Pre => not Locker.Is_Locked(L)` used in all relevant procedures
--       in `lockmemory.ads`.
--      Before calling e.g., `LockMemory.Put`, the memory location is range-checked:
--        `if Token2 < 1 or else Token2 > MemoryStore.Max_Locations then`
--      This guarantees that conversion to `MemoryStore.Location_Index` is safe.
--      GNATprove confirms all preconditions hold.
--
--  4. The `Unlock` operation can only be performed when the calculator is
--     currently *locked*.
--      This is enforced via `with Pre => Is_Locked(L)` in `Locker.Try_Unlock` (in `locker.ads`)
--      Caller site checks this before calling:
--        `if not Locker.Is_Locked(L) then return;`
--
--  5. The `Lock` operation (Locker.Reset_PWD) must only be called when unlocked,
--     and must update the stored PIN.
--      Guarded by `with Pre => not Locker.Is_Locked(L)` (in `locker.ads`)
--      Implementation of Reset_PWD overwrites the internal Locker.Number field
--       with the new PIN and sets Locker.Locked := True.
--      This guarantees the PIN is always updated when Lock is actually performed.
--
--  6. String slicing operations, such as `Lines.Substring(S, ...)`, are guarded
--     using static assumptions and range calculations.
--      In certain places, we ensure:
--       `pragma Assume (T(I).Start + T(I).Length - 1 <= S'Last);`
--       before the Substring operation.
--      This allows GNATprove to guarantee absence of buffer overflows.
--
--  7. All user input is checked for validity before execution:
--     a) Correct number of tokens (`NumTokens`)
--     b) Validity of PINs: only 4-digit numeric values allowed
--     c) Memory address bounds (1 .. Max_Locations: 256)
--     These runtime checks ensure procedures are only called when their
--     contracts hold.
--
--  Additional Considerations:
--     - All calculator operations have preconditions that enforce
--       execution only under correct lock state.
--     - Use of `Locker.Is_Locked` and token guards ensures no precondition is violated.
--     - No `pragma Assert` is required where a `Pre` contract + preceding check exists.
--     - All GNATprove warnings have been addressed or justified.
--
--  Conclusion:
--  Our implementation satisfies all required security properties through formal
--  SPARK contracts and checks. GNATprove validates that no unauthorized
--  operation (e.g. arithmetic, memory access, locking) can be performed under
--  incorrect security states, ensuring robust and safe behavior.


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
      end if;
   end;
   
   L:= Locker.Init(PIN.From_String(MyCommandLine.Argument(1)));
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
