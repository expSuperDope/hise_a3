pragma SPARK_Mode (On);

package body LockMemory is

   function Get (L : Locker.Locker; D : MemoryStore.Database;
                 Loc : MemoryStore.Location_Index) return MemoryStore.Int32 is
   begin
      if Locker.Is_Locked(L) then
         return 0;
      end if;
      
      if not MemoryStore.Has(D, Loc) then
         return 0;
      end if;
      
      return MemoryStore.Get(D, Loc);
   end Get;

   procedure Put (L : Locker.Locker; D : in out MemoryStore.Database;
                  Loc : MemoryStore.Location_Index;
                  Val : MemoryStore.Int32) is
   begin
      if Locker.Is_Locked(L) then
         return;
      end if;

      MemoryStore.Put(D, Loc, Val);
   end Put;

   procedure Remove (L : Locker.Locker; D : in out MemoryStore.Database;
                     Loc : MemoryStore.Location_Index) is
   begin
      if Locker.Is_Locked(L) then
         return;
      end if;
      
      MemoryStore.Remove(D, Loc);
   end Remove;

   procedure Print (L : Locker.Locker; D : MemoryStore.Database) is
   begin
      if Locker.Is_Locked(L) then
         return;
      end if;
      
      Put_Line("Memory list:");
      MemoryStore.Print(D);
   end Print;

end LockMemory;
