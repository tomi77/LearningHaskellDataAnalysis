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
