# Intro

    cabal repl

# Chapter 2

## getColumnInCSV

first example

    csv <- parseCSVFromFile "all_week.csv"
    either (\error -> Left "Problem Reading File") (\csv -> getColumnInCSV csv "mag") csv

second example

    csv <- parseCSVFromFile "all_week.csv"
    either (\error -> Left "Problem Reading File") (\csv -> getColumnInCSV csv "not a column") csv

## applyToColumnInCSV

first example

    csv <- parseCSVFromFile "all_week.csv"
    either (\error -> Left "Problem Reading File") (\csv -> applyToColumnInCSV (average . readColumn) csv "mag") csv

second example

    csv <- parseCSVFromFile "all_week.csv"
    either (\error -> Left "Problem Reading File") (\csv -> applyToColumnInCSV (average . readColumn) csv "not a column") csv

## applyToColumnInCSVFile

    applyToColumnInCSVFile (average . readColumn) "all_week.csv" "mag"
    applyToColumnInCSVFile (maximum . readColumn) "all_week.csv" "mag"
    applyToColumnInCSVFile (minimum . readColumn) "all_week.csv" "mag"

## convertCSVFileToSQL

    convertCSVFileToSQL "all_week.csv" "earthquakes.sql" "oneWeek" ["time TEXT", "latitude REAL", "longitude REAL", "depth REAL", "mag REAL", "magType TEXT", "nst INTEGER", "gap REAL", "dmin REAL", "rms REAL", "net REAL", "id TEXT", "updated TEXT", "place TEXT", "type TEXT"]
    conn <- connectSqlite3 "earthquakes.sql"
    magnitudes <- quickQuery' conn "SELECT mag FROM oneWeek" []
    fromSql $ head $ head magnitudes :: Double
    let magnitudesDouble = map(\ record -> fromSql $ head record :: Double) magnitudes
    average magnitudesDouble

# Chapter 3

## countFieldsInEachRecord

    csv <- parseCSVFromFile "poorFieldsCount.csv"
    either Left (\ csv -> Right $ countFieldsInEachRecord csv) csv

## lineNumbersWithIncorrectCount

    csv <- parseCSVFromFile "poorFieldsCount.csv"
    either Left (\ csv -> Right $ lineNumbersWithIncorrectCount csv) csv

next example

    csv <- parseCSVFromFile "all_week.csv"
    either Left (\ csv -> Right $ lineNumbersWithIncorrectCount csv) csv

## identifyMatchingFields

    identifyMatchingFields (\x -> x =~ "Journ") ["1", "Clark Kent", "Journalist", "Metropolis"] ["Id", "Name", "Profession", "Location"] 0
    identifyMatchingFields (\x -> x =~ "Hero") ["1", "Clark Kent", "Journalist", "Metropolis"] ["Id", "Name", "Profession", "Location"] 0
    identifyMatchingFields (== "Metropolis") ["1", "Clark Kent", "Journalist", "Metropolis"] ["Id", "Name", "Profession", "Location"] 0

## identifyInCSV

    csv <- parseCSVFromFile "poordata.csv"
    either (\error -> Left "CSV Problem") (\ csv -> identifyInCSV (\ x -> x =~ "PA") csv "Number") csv

multiple fields

    csv <- parseCSVFromFile "poordata.csv"
    either (\error -> Left "") (\ csv -> identifyInCSV (\ x -> x =~ "male") csv "Number") csv

## identifyInCSVFile

    identifyInCSVFile (\ x -> x =~ "^$") "poordata.csv" "Number"

better version

    identifyInCSVFile (\ x -> x =~ "^\\s*$") "poordata.csv" "Number"

## identifyInCSVFileFromColumn

    identifyInCSVFileFromColumn (\ x -> not (x =~ "^[1-9][0-9]?/[1-9][0-9]?/[12][0-9][0-9][0-9]$")) "poordata.csv" "Number" "Birthday"

fixed data

    identifyInCSVFileFromColumn (\ x -> not (x =~ "^[1-9][0-9]?/[1-9][0-9]?/[12][0-9][0-9][0-9]$")) "poordataFixed.csv" "Number" "Birthday"

# Chapter 4

    convertCSVFileToSQL "aapl.csv" "aapl.sql" "aapl" ["date STRING", "open REAL", "high REAL", "low REAL", "close REAL", "volume REAL", "adjclose REAL"]

## pullStockClosingPrices

    aapl <- pullStockClosingPrices "aapl.sql" "aapl"
    plot (PNG "aapl.png") $ Data2D [Title "AAPL"] [] $ aapl
    plot (PNG "aapl_line.png") $ Data2D [Title "AAPL", Style Lines] [] $ aapl
    plot (PNG "aapl_oneyear.png") $ Data2D [Title "AAPL", Style Lines] [] $ take 252 aapl

## applyPercentChangeToData

    aapl <- pullStockClosingPrices "aapl.sql" "aapl"
    let aapl252 = take 252 aapl
    let aapl252pc = applyPercentChangeToData aapl252

google

    convertCSVFileToSQL "googl.csv" "googl.sql" "googl" ["date STRING", "open REAL", "high REAL", "low REAL", "close REAL", "volume REAL", "adjclose REAL"]
    googl <- pullStockClosingPrices "googl.sql" "googl"
    let googl252 = take 252 googl
    let googl252pc = applyPercentChangeToData googl252

microsoft

    convertCSVFileToSQL "msft.csv" "msft.sql" "msft" ["date STRING", "open REAL", "high REAL", "low REAL", "close REAL", "volume REAL", "adjclose REAL"]
    msft <- pullStockClosingPrices "msft.sql" "msft"
    let msft252 = take 252 msft
    let msft252pc = applyPercentChangeToData msft252

all data

    plot (PNG "aapl_googl_msft_pc.png") [Data2D [Title "AAPL - One Year, % Change", Style Lines, Color Red] [] aapl252pc, Data2D [Title "GOOGL - One Year, % Change", Style Lines, Color Blue] [] googl252pc, Data2D [Title "MSFT - One Year, % Change", Style Lines, Color Green] [] msft252pc]

## applyMovingAverageToData

    aapl <- pullStockClosingPrices "aapl.sql" "aapl"
    let aapl252 = take 252 aapl
    let aapl252pc = applyPercentChangeToData aapl252
    let aapl252ma20 = applyMovingAverageToData aapl252pc 20
    plot (PNG "aapl_20dayma.png") [Data2D [Title "AAPL - One Year, % Change", Style Lines, Color Red] [] aapl252pc, Data2D [Title "AAPL 20-Day MA", Style Lines, Color Black] [] aapl252ma20]

earthquakes

    convertCSVFileToSQL "all_month.csv" "earthquakes.sql" "oneMonth" ["time TEXT", "latitude REAL", "longitude REAL", "depth REAL", "mag REAL", "magType TEXT", "nst INTEGER", "gap REAL", "dmin REAL", "rms REAL", "net REAL", "id TEXT", "updated TEXT", "place TEXT", "type TEXT"]
    coords <- pullLatitudeLongitude "earthquakes.sql" "oneMonth"
    plot (PNG "earthquakes.png") [Data2D [Title "Earthquakes", Color Red, Style Dots] [] coords]

# Chapter 5

## probabilityMassFunction

    :l src/LearningHaskellDataAnalysis02 src/LearningHaskellDataAnalysis04 src/LearningHaskellDataAnalysis05
    :m LearningHaskellDataAnalysis02 LearningHaskellDataAnalysis04 LearningHaskellDataAnalysis05
    import Graphics.EasyPlot
    plot (PNG "coinflips.png") $ Function2D [Title "Coin Flip Probabilities"] [Range 0 1000] (\ k -> probabilityMassFunction (floor k) 1000 0.5)

perfect

    probabilityMassFunction 500 1000 0.5

sum

    sum $ map (\ k -> probabilityMassFunction k 1000 0.5) [0..1000]

99%

    sum $ map (\ k -> probabilityMassFunction k 1000 0.5) [460..540]

random

    import System.Random
    g <- newStdGen
    random g :: (Double, StdGen)

3 random double

    take 3 $ randoms g :: [Double]

5 random integers from 0 to 100

    take 5 $ randomRs (0, 100) g

random coin flips

    let coinflips = take 1000 $ randomRs (0, 1) g
    sum coinflips

baseball

    import LearningHaskellDataAnalysis02
    convertCSVFileToSQL "winloss2014.csv" "winloss.sql" "winloss" ["date TEXT", "awayteam TEXT", "hometeam TEXT", "awayscore INTEGER", "homescore INTEGER"]
    import LearningHaskellDataAnalysis04
    queryDatabase "winloss.sql" "SELECT SUM(awayscore), SUM(homescore) FROM winloss"
    runsAtHome <- queryDatabase "winloss.sql" "SELECT hometeam, SUM(homescore) FROM winloss GROUP BY hometeam ORDER BY hometeam"
    runsAway <- queryDatabase "winloss.sql" "SELECT awayteam, SUM(awayscore) FROM winloss GROUP BY awayteam ORDER BY awayteam"
    let runsHomeAway = zip (readDoubleColumn runsAtHome 1) (readDoubleColumn runsAway 1)
    import Graphics.EasyPlot
    plot (PNG "HomeScoreAwayScore.png") $ Data2D [Title "Runs at Home (x axis) and RunsAway (y axis)"] [] runsHomeAway
    let runsHomeAwayDiff = map (\ (a, b) -> a - b) runsHomeAway
    plot (PNG "HomeScoreAwayScoreDiff.png") $ Data2D [Title "Difference in Runs at Home and Runs Away"] [] $ zip [1..] runsHomeAwayDiff
    average runsHomeAwayDiff
    standardDeviation runsHomeAwayDiff
    import Data.List
    standardDeviation runsHomeAwayDiff / (sqrt $ genericLength runsHomeAwayDiff)
    plot (PNG "standardNormal.png") $ Function2D [Title "Standard Normal"] [Range (-4) 4] (\ x -> exp(-(x*x)/2)/sqrt(2*pi))

# Chapter 6

    import LearningHaskellDataAnalysis04
    import LearningHaskellDataAnalysis04
    import LearningHaskellDataAnalysis05
    import LearningHaskellDataAnalysis06
    queryDatabase "winloss.sql" "SELECT COUNT(*) FROM winloss"
    queryDatabase "winloss.sql" "SELECT COUNT(*) FROM winloss WHERE awayscore == homescore"
    homeRecord <- queryDatabase "winloss.sql" "SELECT homeTeam, SUM(homescore > awayscore), SUM(homescore), COUNT(*) FROM winloss GROUP BY homeTeam"
    awayRecord <- queryDatabase "winloss.sql" "SELECT awayTeam, SUM(awayscore > homescore), SUM(awayscore), COUNT(*) FROM winloss GROUP BY awayTeam"
    let totalWins = zipWith (+) (readDoubleColumn homeRecord 1) (readDoubleColumn awayRecord 1)
    let totalRuns = zipWith (+) (readDoubleColumn homeRecord 2) (readDoubleColumn awayRecord 2)
    let totalGames = zipWith (+) (readDoubleColumn homeRecord 3) (readDoubleColumn awayRecord 3)
    let winPrecentage = zipWith (/) totalWins totalGames
    let runsPerGame = zipWith (/) totalRuns totalGames
    any (\ xi -> abs((xi - average runsPerGame) / standardDeviation runsPerGame) > 3) runsPerGame
    any (\ xi -> abs((xi - average winPrecentage ) / standardDeviation winPrecentage ) > 3) winPrecentage
    import Graphics.EasyPlot
    plot (PNG "runs_and_wins.png") $ Data2D [Title "Runs per Game VS Win % in 2014", Color Red] [] $ zip runsPerGame winPrecentage
    pearsonR runsPerGame winPrecentage
    pearsonRsqrd runsPerGame winPrecentage
    let (gradient, intercept) = linearRegression runsPerGame winPrecentage
    let winEstimate = map (\ x -> x * gradient + intercept) [3.3, 3.4 .. 4.7]
    let regressionLine = zip [3.3, 3.4 .. 4.7] winEstimate
    plot (PNG "runs_and_wins_with_regression.png") [Data2D [Title "Runs per Game VS Win % in 2014", Color Red] [] (zip runsPerGame winPrecentage), Data2D [Title "Regression Line", Style Lines, Color Blue] [] regressionLine]
