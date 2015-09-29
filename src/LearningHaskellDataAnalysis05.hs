module LearningHaskellDataAnalysis05 where
import Math.Combinatorics.Exact.Binomial
import Data.List
import LearningHaskellDataAnalysis02

probabilityMassFunction :: (Integral a) => a -> a -> Double -> Double
probabilityMassFunction k n p =
  (fromIntegral (n `choose` k)) * (p ^ k) * ((1 - p) ^ (n - k))

standardDeviation :: [Double] -> Double
standardDeviation values =
    (sqrt . sum $ map (\ x -> (x - mu) * (x - mu)) values) / sqrt_nml
  where
    mu = average values
    sqrt_nml = sqrt $ (genericLength values - 1)
