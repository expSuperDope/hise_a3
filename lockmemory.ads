pragma SPARK_Mode (On);

with MemoryStore;
with Locker;
with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package LockMemory is
   
   function  Get    (L:Locker.Locker; D: MemoryStore.Database; Loc: MemoryStore.Location_Index) 
                     return MemoryStore.Int32
     with Pre => not Locker.Is_Locked(L);
     
   procedure Put    (L:Locker.Locker; D: in out MemoryStore.Database;
                     Loc: in MemoryStore.Location_Index; Val: in MemoryStore.Int32)
     with Pre => not Locker.Is_Locked(L);
   
   procedure Remove (L:Locker.Locker; D: in out MemoryStore.Database; Loc: in MemoryStore.Location_Index)
   with Pre => not Locker.Is_Locked(L);
   
   procedure Print  (L:Locker.Locker; D: MemoryStore.Database)
   with Pre => not Locker.Is_Locked(L);

end LockMemory;
