pragma SPARK_Mode (On);

package body LockMemory is

   function Get (L : Locker.Locker; D : MemoryStore.Database;
                 Loc : MemoryStore.Location_Index) return MemoryStore.Int32 is
   begin
      
      if not MemoryStore.Has(D, Loc) then
         return 0;
      end if;
      
      return MemoryStore.Get(D, Loc);
   end Get;

   procedure Put (L : Locker.Locker; D : in out MemoryStore.Database;
                  Loc : MemoryStore.Location_Index;
                  Val : MemoryStore.Int32) is
   begin

      MemoryStore.Put(D, Loc, Val);
   end Put;

   procedure Remove (L : Locker.Locker; D : in out MemoryStore.Database;
                     Loc : MemoryStore.Location_Index) is
   begin
      
      MemoryStore.Remove(D, Loc);
   end Remove;

   procedure Print (L : Locker.Locker; D : MemoryStore.Database) is
   begin
      
      Put_Line("Memory list:");
      MemoryStore.Print(D);
   end Print;

end LockMemory;
