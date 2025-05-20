with Interfaces;

package Calculator with SPARK_Mode is

   subtype Int32 is Interfaces.Integer_32; 
   subtype Int64 is Interfaces.Integer_64; 
   
   type Result is record
      Success   : Boolean;
      Div_Zero  :Boolean;
      Value     : Int32;
   end record;

   function Add (A, B : Int32) return Result;
   function Sub (A, B : Int32) return Result;
   function Mul (A, B : Int32) return Result;
   function Div (A, B : Int32) return Result;

end calculator;
