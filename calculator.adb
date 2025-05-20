use type Calculator.Int64;
use type Calculator.Int32;

package body Calculator with SPARK_Mode is
    
   function  Add(A, B: Int32) return Result is 
      V: Int64 := Int64(A) + Int64(B);
   begin
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         return (Success=> False, Div_Zero => False, Value => 0);
      else
         return (Success=> True,  Div_Zero => False, Value => Int32(V));
      end if;
   end Add;
     
   
   function  Sub(A, B: Int32) return Result is 
      V: Int64 := Int64(A) - Int64(B);
   begin
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         return (Success=> False, Div_Zero => False, Value => 0);
      else
         return (Success=> True,  Div_Zero => False, Value => Int32(V));
      end if;
   end Sub;
   
   
   function  Mul(A, B: Int32) return Result is 
      V: Int64 := Int64(A) * Int64(B);
   begin
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         return (Success=> False, Div_Zero => False, Value => 0);
      else
         return (Success=> True,  Div_Zero => False, Value => Int32(V));
      end if;
   end Mul;
   
   
   function  Div(A, B: Int32) return Result is 
      V: Int64 := 0;
   begin
      if B = 0 then
         return (Success => False, Value => 0, Div_Zero => True);
      end if;
      
      V := Int64(A) / Int64(B);
      if(V < Int64(Int32'First) or else V > Int64(Int32'Last)) then
         return (Success=> False, Div_Zero => False, Value => 0);
      else
         return (Success=> True,  Div_Zero => False, Value => Int32(V));
      end if;
   end Div;
   
end calculator;
