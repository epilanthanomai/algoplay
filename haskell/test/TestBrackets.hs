module TestBrackets (bracketTests) where

import Test.HUnit
import Brackets (bracketsMatch)

bracketTests = [
    "empty" ~: bracketsMatch "" ~=? True,
    "parens" ~: bracketsMatch "()" ~=? True,
    "square" ~: bracketsMatch "[]" ~=? True,
    "curly" ~: bracketsMatch "{}" ~=? True,
    "bare close" ~: bracketsMatch ")" ~=? False,
    "bare mismatch" ~: bracketsMatch "(]" ~=? False,
    "nesting mismatch" ~: bracketsMatch "([]{)" ~=? False,
    "complex nesting" ~: bracketsMatch "([]{([])})" ~=? True
  ]
