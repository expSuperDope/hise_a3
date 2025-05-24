with Locker, Stack, Calculator, LockMemory, MemoryStore;
with MyString;
with MyString_Instance;

package CommandHandler with SPARK_Mode is

   use MyString_Instance;

   procedure Execute(
      L  : in out Locker.Locker;
      Sk : in out Stack.Stack_Instance;
      D  : in out MemoryStore.Database;
      S  : Lines.MyString 
   );

end CommandHandler;
