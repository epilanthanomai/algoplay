import System.Exit
import Test.HUnit

import TestBrackets (bracketTests)

suite = test [
    "001" ~: bracketTests
  ]

main = do
  results <- runTestTT suite
  if errors results + failures results > 0
    then exitFailure
    else exitSuccess
