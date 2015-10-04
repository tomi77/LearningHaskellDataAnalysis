module LearningHaskellDataAnalysis06 where

  import Data.List
  import Graphics.EasyPlot
  import LearningHaskellDataAnalysis02
  import LearningHaskellDataAnalysis04
  import LearningHaskellDataAnalysis05

  {- Covariance -}
  covariance :: [Double] -> [Double] -> Double
  covariance x y = average $ zipWith (\ xi yi -> (xi - xavg) * (yi - yavg)) x y
    where
      xavg = average x
      yavg = average y

  {- Pearson r Correlation Coefficient -}
  pearsonR :: [Double] -> [Double] -> Double
  pearsonR x y = r
    where
      xstdev = standardDeviation x
      ystdev = standardDeviation y
      r = covariance x y / (xstdev * ystdev)

  {- Pearson r-squared -}
  pearsonRsqrd :: [Double] -> [Double] -> Double
  pearsonRsqrd x y = pearsonR x y ^ 2

  {- Perform simple linear regression to find a best-fit line.
    Returns a tuple of (gradient, intercept) -}
  linearRegression :: [Double] -> [Double] -> (Double, Double)
  linearRegression x y = (gradient, intercept)
    where
      xavg = average x
      yavg = average y
      xstdev = standardDeviation x
      gradient = covariance x y / (xstdev * xstdev)
      intercept = yavg - gradient * xavg
