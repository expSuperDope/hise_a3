pragma SPARK_Mode(On);
with PIN;
with Ada.Text_IO; use Ada.Text_IO;

package body Locker is

   procedure Init(L : in out Locker; N : PIN.PIN) is
   begin
      L.Number := N;
      L.Locked := True;  
   end Init;

   procedure Try_Unlock(L : in out Locker; N : PIN.PIN) is
   begin
      if L.Locked then
         if N = L.Number then
            L.Locked := False;
         end if;
      end if;
   end Try_Unlock;

   procedure Reset_PWD(L : in out Locker; N : PIN.PIN) is
   begin
      if not L.Locked then
         L.Number := N;
         L.Locked := True;
      end if;
   end Reset_PWD;

   function Is_Locked(L : Locker) return Boolean is
   begin
      return L.Locked;
   end Is_Locked;

end Locker;
