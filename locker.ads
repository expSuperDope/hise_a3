pragma SPARK_Mode(On);
with PIN;
use type PIN.PIN;

package Locker is

   type Locker is private;
   
   procedure Init(L : in out Locker; N : PIN.PIN);

   procedure Try_Unlock(L : in out Locker; N : PIN.PIN);

   procedure Reset_PWD(L : in out Locker; N : PIN.PIN);
     
   function Is_Locked(L : Locker) return Boolean;

private

   type Locker is record
      Number : PIN.PIN;     
      Locked : Boolean;  -- True = Locked, False = Unlocked
   end record;

end Locker;
