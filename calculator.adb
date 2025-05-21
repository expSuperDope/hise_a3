use type Calculator.Int64;
use type Calculator.Int32;

package body Calculator with SPARK_Mode is
    
   function  Add(L: Locker.Locker; A, B: Int32) return Result is 
      V: Int64 := Int64(A) + Int64(B);
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         return (Success=>False, Value=>0);
      end if;
           
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         Put_Line("Results overflows!");
         return (Success=>False, Value=>0);
      else
         Put_Line("Result: " & Int32'Image(A) & " + " & Int32'Image(B) & " = " & Int64'Image(V));
         return (Success=>True,  Value=>Int32(V));
      end if;
   end Add;
     
   
   function  Sub(L: Locker.Locker; A, B: Int32) return Result is 
      V: Int64 := Int64(A) - Int64(B);
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         return (Success=>False, Value=>0);
      end if;
        
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         Put_Line("Results overflows!");
         return (Success=>False, Value=>0);
      else
         Put_Line("Result: " & Int32'Image(A) & " - " & Int32'Image(B) & " = " & Int64'Image(V));
         return (Success=>True,  Value=>Int32(V));
      end if;
   end Sub;
   
   
   function  Mul(L: Locker.Locker; A, B: Int32) return Result is 
      V: Int64 := Int64(A) * Int64(B);
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         return (Success=>False, Value=>0);
      end if;
      
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         Put_Line("Results overflows!");
         return (Success=>False, Value=>0);
      else
         Put_Line("Result: " & Int32'Image(A) & " * " & Int32'Image(B) & " = " & Int64'Image(V));
         return (Success=>True, Value=>Int32(V));
      end if;
   end Mul;
   
   
   function  Div(L: Locker.Locker; A, B: Int32) return Result is 
      V: Int64 := 0;
   begin
      if Locker.Is_Locked(L) then
         Put_Line("Locked!");
         return (Success=>False, Value=>0);
      end if;
        
      if B = 0 then
         Put_Line("Div 0!");
         return (Success=>False, Value=>0);
      end if;
      
      V := Int64(A) / Int64(B);
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         Put_Line("Results overflows!");
         return (Success=> False, Value => 0);
      else
         Put_Line("Result: " & Int32'Image(A) & " / " & Int32'Image(B) & " = " & Int64'Image(V));
         return (Success=>True, Value=>Int32(V));
      end if;
   end Div;
   
end calculator;
