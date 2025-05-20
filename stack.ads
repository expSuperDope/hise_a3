pragma SPARK_Mode(On);
with Interfaces;

package Stack is
   
   Max_Capacity : constant := 512;

   subtype Stack_Index is Positive range 1 .. Max_Capacity;
   subtype Int32 is Interfaces.Integer_32;
   
   type Stack_Array is array (Stack_Index) of Int32;


   type Stack_Instance is private;
   
   procedure Init(S : out Stack_Instance);

   procedure Push(S : in out Stack_Instance; A : Int32; Success : in out Boolean);

   procedure Push2(S : in out Stack_Instance; A, B : Int32; Success : in out Boolean);

   procedure Pop(S : in out Stack_Instance; A : out Int32; Success : in out Boolean);

   procedure Pop2(S : in out Stack_Instance; A, B : out Int32; Success : in out Boolean);
   
private

   type Stack_Instance is record
      Data       : Stack_Array;
      Top_Index  : Natural := 0;
   end record;

end stack;
