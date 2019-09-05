module TwentyFour (
  hasMatch,
) where

-- https://en.wikipedia.org/wiki/24_Game

import Data.Ratio (Ratio)

data Term n = NumericTerm n |
              BinaryTerm (BinaryOperator n) (Term n) (Term n)
data BinaryOperator n = BinaryOperator (n -> n -> n) String

instance Show n => Show (Term n) where
  show (NumericTerm n) = show n
  show (BinaryTerm (BinaryOperator _ rep) a b) = "(" ++ (show a) ++ " " ++ rep ++ " " ++ (show b) ++ ")"

ops :: Integral n => [BinaryOperator (Ratio n)]
ops = [
    BinaryOperator (+) "+",
    BinaryOperator (-) "-",
    BinaryOperator (*) "*",
    BinaryOperator (/) "/"
  ]

eval :: Term n -> n
eval (NumericTerm n) = n
eval (BinaryTerm (BinaryOperator f _)  a b) = f (eval a) (eval b)

hasMatch :: Integral n => Ratio n -> [Ratio n] -> Bool
hasMatch target nums = case matches of h : _ -> True
                                       _ -> False
  where matches = filter match $ combine $ map NumericTerm nums
        match term = eval term == target

combine :: Integral n => [Term (Ratio n)] -> [Term (Ratio n)]
combine [] = []
combine [t] = [t]
combine ts = do
  (a, rest) <- pickOne ts
  (b, rest') <- pickOne rest
  op <- ops
  t <- mkBinaryTerm op a b
  combine $ t : rest'

mkBinaryTerm :: (Num n, Eq n) => BinaryOperator n -> Term n -> Term n -> [Term n]
mkBinaryTerm op@(BinaryOperator _ "/") a b
  | eval b == 0 = []
  | otherwise = [BinaryTerm op a b]
mkBinaryTerm op a b = [BinaryTerm op a b]

-- This is probably just a fold, but I'm not seeing it...
pickOne :: [a] -> [(a, [a])]
pickOne (t : ts) = pickOne' [] t ts
  where pickOne' before t [] = [(t, before)]
        pickOne' before t after@(t' : ts') = (t, before ++ after) : pickOne' (before ++ [t]) t' ts'
