module LearningHaskellDataAnalysis04 where
import Data.List
import Database.HDBC.Sqlite3
import Database.HDBC
import Graphics.EasyPlot
import LearningHaskellDataAnalysis02

readIntegerColumn :: [[SqlValue]] -> Integer -> [Integer]
readIntegerColumn sqlResult index = map (\ row -> fromSql $ genericIndex row index :: Integer) sqlResult

readDoubleColumn :: [[SqlValue]] -> Integer -> [Double]
readDoubleColumn sqlResult index = map (\ row -> fromSql $ genericIndex row index :: Double) sqlResult

readStringColumn :: [[SqlValue]] -> Integer -> [String]
readStringColumn sqlResult index = map (\ row -> fromSql $ genericIndex row index :: String) sqlResult

queryDatabase :: FilePath -> String -> IO [[SqlValue]]
queryDatabase databaseFile sqlQuery = do
    conn <- connectSqlite3 databaseFile
    result <- quickQuery' conn sqlQuery []
    disconnect conn
    return  result

pullStockClosingPrices :: String -> String -> IO [(Double, Double)]
pullStockClosingPrices databaseFile database = do
    sqlResult <- queryDatabase databaseFile ("SELECT rowid, adjclose FROM " ++ database)
    return $ zip (reverse $ readDoubleColumn sqlResult 0) (readDoubleColumn sqlResult 1)

percentChange :: Double -> Double -> Double
percentChange value first = 100.0 * (value - first) / first

applyPercentChangeToData :: [(Double, Double)] -> [(Double, Double)]
applyPercentChangeToData dataset = zip indices scaledData
  where
    (_, first) = last dataset
    indices = reverse [1.0..(genericLength dataset)]
    scaledData = map (\ (_, value) -> percentChange value first) dataset

movingAverage :: [Double] -> Integer -> [Double]
movingAverage values window =
    if window >= genericLength values
    then [average values]
    else average (genericTake window values):(movingAverage (tail values) window)

applyMovingAverageToData :: [(Double, Double)] -> Integer -> [(Double, Double)]
applyMovingAverageToData dataset window =
    zip [fromIntegral window..] $ movingAverage (map snd (reverse dataset)) window

pullLatitudeLongitude :: String -> String -> IO [(Double, Double)]
pullLatitudeLongitude databaseFile database = do
  sqlResult <- queryDatabase
    databaseFile
    ("SELECT latitude, longitude FROM " ++ database)
  return $ zip (readDoubleColumn sqlResult 1) (readDoubleColumn sqlResult 0)
