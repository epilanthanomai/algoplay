module TestTwentyFour (twentyFourTests) where

import Test.HUnit
import TwentyFour (hasMatch)

twentyFourTests = [
    "positive" ~: hasMatch 24 [5,2,7,8] ~=? True,  -- (5 * 2 - 7) * 8
    "negative" ~: hasMatch 24 [1,1,1,1] ~=? False
  ]
