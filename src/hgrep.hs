import Text.Regex.Posix ((=~))
import System.Environment (getArgs)

myGrep :: String -> String -> IO ()
myGrep myRegex filename = do
    fileSlurp <- readFile filename
    mapM_ putStrLn $ filter (=~ myRegex) (lines fileSlurp)

main :: IO ()
main = do
    (myRegex:filenames) <- getArgs
    mapM_ (\ filename -> myGrep myRegex filename) filenames
