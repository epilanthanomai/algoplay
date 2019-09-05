import System.Exit
import Test.HUnit

import TestBrackets (bracketTests)
import TestTwentyFour (twentyFourTests)

suite = test [
    "001" ~: bracketTests,
    "002" ~: twentyFourTests
  ]

main = do
  results <- runTestTT suite
  if errors results + failures results > 0
    then exitFailure
    else exitSuccess
