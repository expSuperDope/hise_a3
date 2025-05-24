pragma SPARK_Mode (On);

with Interfaces;
with Locker;
with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package Calculator with SPARK_Mode is

   subtype Int32 is Interfaces.Integer_32; 
   subtype Int64 is Interfaces.Integer_64; 
   
   type Result is record
      Success   :Boolean;
      Value     :Int32;
   end record;

   function Add (L: Locker.Locker; A, B : Int32) return Result
     with Pre => not Locker.Is_Locked(L);
   
   function Sub (L: Locker.Locker; A, B : Int32) return Result
     with Pre => not Locker.Is_Locked(L);
   
   function Mul (L: Locker.Locker; A, B : Int32) return Result
     with Pre => not Locker.Is_Locked(L);
   
   function Div (L: Locker.Locker; A, B : Int32) return Result
     with Pre => not Locker.Is_Locked(L);


end calculator;
