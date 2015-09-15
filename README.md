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
