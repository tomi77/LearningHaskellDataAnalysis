module LearningHaskellDataAnalysis02 where
import Data.List
import Data.Either
import Text.CSV
import Database.HDBC
import Database.HDBC.Sqlite3

-- Compute the average of a list of values
average :: (Real a, Fractional b) => [a] -> b
average xs = realToFrac(sum xs) / fromIntegral(length xs)

getColumnInCSV :: CSV -> String -> Either String Integer
getColumnInCSV csv columnName =
  case lookupResponse of
    Nothing -> Left "The column does not exist in this CSV file."
    Just x -> Right (fromIntegral x)
  where
  -- This line looks to see if column is in our CSV
  lookupResponse = findIndex (== columnName) (head csv)

applyToColumnInCSV :: ([String] -> b) -> CSV -> String -> Either String b
applyToColumnInCSV func csv column = either
    Left
    (Right . func . elements)
    columnIndex
  where
  columnIndex = getColumnInCSV csv column
  nfieldsInFile = length $ head csv
  records = tail $ filter (\record -> nfieldsInFile == length record) csv
  elements ci = map (\record -> genericIndex record ci) records

readColumn :: [String] -> [Double]
readColumn xs = map read xs

-- Opens a CSV file and applies a function to a column
-- Returns Either Error Message or the function result
applyToColumnInCSVFile :: ([String] -> b) -> FilePath -> String -> IO (Either String b)
applyToColumnInCSVFile func inFileName column = do
  -- Open and read CSV file
  input <- readFile inFileName
  let records = parseCSV inFileName input
  -- Check to make sure this is a good csv file
  return $ either
    handleCSVError
    (\ csv -> applyToColumnInCSV func csv column)
    records
  where
    handleCSVError csv = Left "This does not appear to be a CSV file."

-- Converts a CSV expression into an SQL database
-- Returns "Successful" if successful,
-- error message otherwise.
convertCSVToSQL :: String -> FilePath -> [String] -> CSV -> IO ()
convertCSVToSQL tableName outFileName fields records =
  -- Check to make sure that the number of
  --   columns matches the number of fields
  if nfieldsInFile == nfieldsInFields then do
    -- Open a connection
    conn <- connectSqlite3 outFileName

    -- Create a new table
    run conn createStatement []

    -- Load contents of CSV file into table
    stmt <- prepare conn insertStatement
    executeMany stmt (tail (filter (\ record -> nfieldsInFile == length record) sqlRecords))

    -- Commit changes
    commit conn

    -- Close the connection
    disconnect conn

    -- Report that we were successful
    putStrLn "Successful"
  else
    putStrLn "The number of input fields differ from the csv file."
  where
    nfieldsInFile = length $ head records
    nfieldsInFields = length fields
    createStatement = "CREATE TABLE " ++ tableName ++ " (" ++  (intercalate ", " fields) ++ ")"
    insertStatement = "INSERT INTO " ++ tableName ++ " VALUES (" ++ (intercalate ", " (replicate nfieldsInFile "?")) ++ ")"
    sqlRecords = map (\ record -> map (\ element -> toSql element) record) records

-- Converts a CSV file to an SQL database file
-- Prints "Successful" if successful, error message otherwise
convertCSVFileToSQL :: String -> String -> String -> [String] -> IO ()
convertCSVFileToSQL inFileName outFileName tableName fields = do
    -- Open and read the CSV file
    input <- readFile inFileName
    let records = parseCSV inFileName input

    -- Check to make sure this is a good csv file
    either handleCSVError convertTool records
  where
    convertTool = convertCSVToSQL tableName outFileName fields
    handleCSVError csv = putStrLn "This does not appear to be a CSV file."
