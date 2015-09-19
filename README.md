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
