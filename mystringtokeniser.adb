
package body MyStringTokeniser with SPARK_Mode is



   procedure Tokenise(S : in String; Tokens : in out TokenArray; Count : out Natural) is
      Index : Positive;
      Extent : TokenExtent;
      Processed : Natural := 0;
      OutIndex : Integer := Tokens'First;
   begin
      Count := 0;
      if (S'First > S'Last) then
         return;
      end if;
      Index := S'First;
      while OutIndex <= Tokens'Last and Index <= S'Last and Processed < Tokens'Length loop
         pragma Loop_Invariant
           (for all J in Tokens'First..OutIndex-1 =>
              (Tokens(J).Start >= S'First and
                   Tokens(J).Length > 0) and then
            Tokens(J).Length-1 <= S'Last - Tokens(J).Start);
         -- Loop Invariant 1:
         -- This ensures that all stored tokens are valid:
         --      Each token's Start position is not beyond in the left boundary of the input S.
         --      Each token has a Length > 0 (no empty tokens).
         --      Given that Length > 0, the last character of each token does not exceed S's right boundary.
         -- These make sure that all tokens are non empty and in S's bounds to prevent out of bounds issues.

         pragma Loop_Invariant (OutIndex = Tokens'First + Processed);
         -- Loop Invariant 2:
         -- This means that the index for the next token to be written (OutIndex)
         -- must equal the starting index of the Tokens array (Tokens'First) plus the number
         -- of tokens already processed (Processed).
         --
         -- For example, if one token has already been processed, it satisfies:
         --     2 (OutIndex) = 1 (Tokens'First) + 1 (Processed)
         --
         -- It ensures that all tokens are written into the Tokens array in order and
         -- continuously, and that each writing is to the correct index.



         -- look for start of next token
         while (Index >= S'First and Index < S'Last) and then Is_Whitespace(S(Index)) loop
            Index := Index + 1;
         end loop;
         if (Index >= S'First and Index <= S'Last) and then not Is_Whitespace(S(Index)) then
            -- found a token
            Extent.Start := Index;
            Extent.Length := 0;

            -- look for end of this token
            while Positive'Last - Extent.Length >= Index
              and then (Index+Extent.Length >= S'First and Index+Extent.Length <= S'Last)
              and then not Is_Whitespace(S(Index+Extent.Length)) loop
               Extent.Length := Extent.Length + 1;
            end loop;

            Tokens(OutIndex) := Extent;
            Processed := Processed + 1;

            -- check for last possible token, avoids overflow when incrementing OutIndex
            if (OutIndex = Tokens'Last) then
               Count := Processed;
               return;
            else
               OutIndex := OutIndex + 1;
            end if;

            -- advance to first character after the token
            Index := Index + Extent.Length;
         end if;
      end loop;
      Count := Processed;
   end Tokenise;

end MyStringTokeniser;
