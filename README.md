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
