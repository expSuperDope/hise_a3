pragma SPARK_Mode(On);
with PIN;
use type PIN.PIN;

package Locker is

   type Locker is private;
   
   function Init(N : PIN.PIN) return Locker;

   procedure Try_Unlock(L : in out Locker; N : PIN.PIN)
    with pre => Is_Locked(L);
   
   procedure Reset_PWD(L : in out Locker; N : PIN.PIN)
    with pre => not Is_Locked(L);
     
   function Is_Locked(L : Locker) return Boolean;

private

   type Locker is record
      Number : PIN.PIN;     
      Locked : Boolean;  -- True = Locked, False = Unlocked
   end record;

end Locker;
