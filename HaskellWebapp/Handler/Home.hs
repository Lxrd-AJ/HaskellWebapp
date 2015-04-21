module Handler.Home where

import Import
import qualified Network.HTTP as HP 
import Control.Applicative ()
import Control.Monad()
import qualified Data.ByteString.Lazy.Char8() 
import qualified Data.ByteString.Lazy.Char8() 
import qualified Data.Text as T 
import qualified Data.ByteString.Lazy as BS 
import Control.Monad (when)
import Data.Aeson
import GHC.Generics
import Network.HTTP.Conduit( simpleHttp )
import qualified Data.List as LS
import Data.Time.Format     (parseTime,formatTime)
import Data.Time.Clock      (UTCTime)
--import System.Locale        (defaultTimeLocale)
import Data.Maybe


-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes

-- /
-- Get the response
-- Store it in the database( fork a thread to do this )
-- return the EmberJS webapp
getJSON :: IO BS.ByteString
getJSON = simpleHttp "http://www.phoric.eu/temperature"

{-
makeTimeString :: UTCTime -> String
makeTimeString = formatTime defaultTimeLocale "%FT%T%QZ"

makeStringTime :: String -> Maybe UTCTime
makeStringTime = parseTime defaultTimeLocale "%FT%T%QZ"
-}

getTemperatures :: IO Text
getTemperatures = do 
        d <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
        case d of 
            Left error -> return (T.pack error)
            Right result -> return (averageTemp result)

unwarpTemperatures :: Temperatures -> [Temperature]
unwarpTemperatures (Temperatures {temperatures = xs}) = xs 

getDate :: Temperature -> String
getDate (Temperature {date = d, temperature = temp }) = T.unpack d

myDate :: [Temperature] -> [String]
myDate [] = []
myDate (x:xs) = getDate x : myDate xs 

averageTemp :: Temperatures -> [String] 
averageTemp ts = do
    temps <- unwarpTemperatures ts 
    myDate [temps]

retrieveResponse :: IO String 
retrieveResponse = do 
    result <- HP.simpleHTTP (HP.getRequest "http://www.phoric.eu/temperature") 
    (HP.getResponseBody result) 

getHomeR :: Handler Text
getHomeR = lift getTemperatures

-- try using addScriptRemote
