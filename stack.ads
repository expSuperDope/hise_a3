pragma SPARK_Mode(On);
with Interfaces;
with Locker;
with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package Stack is
   
   Max_Capacity : constant := 512;
   --Max_Capacity : constant := 2;

   subtype Stack_Index is Positive range 1 .. Max_Capacity;
   subtype Int32 is Interfaces.Integer_32;
   
   type Stack_Array is array (Stack_Index) of Int32;


   type Stack_Instance is private;
   
   procedure Init(S : out Stack_Instance);

   procedure Push(L:Locker.Locker; S : in out Stack_Instance; A : Int32; Success : in out Boolean)
     with Pre => not Locker.Is_Locked(L);
   
   procedure Push2(L:Locker.Locker; S : in out Stack_Instance; A, B : Int32; Success : in out Boolean)
     with Pre => not Locker.Is_Locked(L);
   
   procedure Pop(L:Locker.Locker; S : in out Stack_Instance; A : out Int32; Success : in out Boolean)
     with Pre => not Locker.Is_Locked(L);
   
   procedure Pop2(L:Locker.Locker; S : in out Stack_Instance; A, B : out Int32; Success : in out Boolean)
     with Pre => not Locker.Is_Locked(L);
   
private

   type Stack_Instance is record
      Data       : Stack_Array;
      Top_Index  : Natural := 0;
   end record;

end stack;
