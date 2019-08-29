module Brackets (
  makeBracketMap,
  bracketsMatchM,
  bracketsMatch
) where

import Control.Monad (foldM, (>>=))
import Data.Maybe (catMaybes)
import qualified Data.Map as Map

-- A BracketClass represents a particular type of brackets we're balancing:
-- parens, square brackets, etc. In practice we just store that as the open
-- bracket of the pair.
type BracketClass = Char
-- We accumulate bracket state while checking their balance. We need a stack
-- of open brackets, which we'll represent as an array.
type BracketState = [BracketClass]
-- A BracketMap is a quick static lookup matching the bracket characters we
-- recognize to the ParsedBracket they represent.
type BracketMap = Map.Map Char Bracket
-- A BracketPair is specifically a two-character string containing matched
-- open and close brackets.
type BracketPair = String

data Direction = Close | Open deriving (Eq, Show)
data Bracket = Bracket Direction BracketClass deriving (Eq, Show)

-- Parse a single Char into a Bracket by looking it up in the BracketMap.
parseBracket :: BracketMap -> Char -> Maybe Bracket
parseBracket = flip Map.lookup

-- Parse a whole String into Brackets by parsing the individual Chars and
-- throwing out the ones that aren't Brackets.
parseBrackets :: BracketMap -> String -> [Bracket]
parseBrackets bracketMap = catMaybes . map (parseBracket bracketMap)

-- Collect a single parsed Bracket into the current BracketState, returning
-- an updated BracketState, or Nothing for an invalid state. Open brackets
-- always push onto the open bracket stack. Close brackets pop from that
-- stack if they match the head, otherwise they fail.
consumeBracket :: BracketState -> Bracket -> Maybe BracketState
consumeBracket stack (Bracket Open b) = Just (b : stack)
consumeBracket (h : rest) (Bracket Close b) | b == h = Just rest
consumeBracket _ _ = Nothing

-- Brackets are balanced when we successfully consume all the Brackets, and
-- the resulting BracketState is an empty bracket stack. If the sequence was
-- invalid or the stack contained unclosed brackets after parsing, they are
-- unbalanced.
bracketsBalanced :: [Bracket] -> Bool
bracketsBalanced s = foldM consumeBracket [] s == Just []

-- For Brackets in a particular BracketMap, check if the String represents a
-- balanced bracket set.
bracketsMatchM :: BracketMap -> String -> Bool
bracketsMatchM bracketMap = bracketsBalanced . parseBrackets bracketMap

-- For Brackets in the default bracket set, check if the String represents a
-- balanced bracket set.
bracketsMatch :: String -> Bool
bracketsMatch = bracketsMatchM $ makeBracketMap defaultBrackets

defaultBrackets :: [BracketPair]
defaultBrackets = ["()", "[]", "{}"]

-- Convert a list of bracket pairs (structured like defaultBrackets) to a
-- BracketMap
makeBracketMap :: [BracketPair] -> BracketMap
makeBracketMap = Map.fromList . (>>= makeBrackets)

-- Convert a single bracket pair string to a BracketMap kv pair
makeBrackets :: BracketPair -> [(Char, Bracket)]
makeBrackets [open, close] = [ (open, Bracket Open open),
                               (close, Bracket Close open) ]
