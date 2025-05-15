with Ada.Characters.Latin_1;

package MyStringTokeniser with SPARK_Mode is

   type TokenExtent is record
      Start : Positive;
      Length : Natural;
   end record;

   type TokenArray is array(Positive range <>) of TokenExtent;

   function Is_Whitespace(Ch : Character) return Boolean is
     (Ch = ' ' or Ch = Ada.Characters.Latin_1.LF or
        Ch = Ada.Characters.Latin_1.HT);

   procedure Tokenise(S : in String; Tokens : in out TokenArray; Count : out Natural) with
     Pre => (if S'Length > 0 then S'First <= S'Last) and Tokens'First <= Tokens'Last,
     Post => Count <= Tokens'Length and                                  --Line 1
     (for all Index in Tokens'First..Tokens'First+(Count-1) =>           --Line 2
          (Tokens(Index).Start >= S'First and                            --Line 3
          Tokens(Index).Length > 0) and then                             --Line 4
            Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start);     --Line 5


-- Task 1.1:
-- Line 1: The final value of Count (the number of tokens found) must be less than
--         or equal to the number of elements the Tokens array can hold.
--
--         This postcondition ensures that accessing Tokens(1 .. Count) remains within
--         the valid bounds of the array to prevent out of bounds errors.
--
--         For example:  Tokens:TokenArray(1 .. 5);
--                       Count:Natural:=6;
--
--         Accessing Tokens(6) would exceed the array bounds, if postcondition
--         does not exist and Tokens(6) would cause out of bounds error.
--
-- Line 2: Count is the number of tokens counted by the Tokenise. When Tokens'Last >
--         Tokens'First + (Count - 1), it means the space beyond Tokens'First +
--         (Count - 1) are unused and can be ignored.
--
--         The Index is the positions of all stored tokens, and each must satisfy
--         the conditions listed of Lines 3, 4, and 5.
--
-- Line 3: Tokens(Index).Start >= S'First ensures that each token starts at a valid
--         position within the range of the input string S, it does not exceed its
--         minimum boundary.
--
--         If Start < S'First, the program would access the position outside of S,
--         which would cause a error or a crash.
--
--         This postcondition prevents out of bounds access and guarantees memory safety.
--
-- Line 4: Tokens(Index).Length > 0 means each token's length must be greater than 0. In
--         other words, tokens cannot be empty.
--
--         If removing condition, the program may regard the null string as a token.
--         This is meaningless leading to incorrect token counts, even infinite loops.
--
--         This flaw must be avoided via post check to ensure safe behaviour.
--
-- Line 5: Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start ensures that each token
--         ends at a valid position within the range of the input string S, it does not
--         exceed its maximum boundary.
--
--         In addition, and then(in Line 4) make sure Tokens(Index).Length-1 would not be less
--         then 0. Because Length is Natural variable, this would cause error if Tokens(Index).Length-1 < 0.
--
--         If Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start, the program would access
--         the position outside of S, which would cause a error or a crash.
--
--         This postcondition prevents out of bounds access and guarantees memory safety.



end MyStringTokeniser;
