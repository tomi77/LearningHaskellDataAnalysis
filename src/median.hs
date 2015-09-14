import System.Environment (getArgs)
import LearningHaskellDataAnalysis01

main :: IO ()
main = do
  values <- getArgs
  print . median $ map read values
