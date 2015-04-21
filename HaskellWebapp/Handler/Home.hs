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
import Data.Time.Clock      (UTCTime)
import Data.Maybe
import qualified Data.Text as T 
import Control.Concurrent (forkIO)
import Data.Time.ISO8601 -- [docs] := https://hackage.haskell.org/package/iso8601-time-0.1.3/docs/Data-Time-ISO8601.html

-- /
-- Get the response
-- Store it in the database( fork a thread to do this )
-- return the EmberJS webapp
getJSON :: IO BS.ByteString
getJSON = simpleHttp "http://www.phoric.eu/temperature"

unwrapTemperatures :: Temperatures -> [Temperature]
unwrapTemperatures (Temperatures {temperatures = xs}) = xs 

getAndStoreTemperatures :: IO ()
getAndStoreTemperatures = do 
        d <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
        case d of 
            Left error -> return ()
            Right result -> (storeTemperatures result)

storeTemperatures :: Temperatures -> IO ()
storeTemperatures temprs = do 
    temps <- unwrapTemperatures temprs 
    (map storeTemperature temps)

storeTemperature :: Temperature -> Handler ()
storeTemperature (Temperature d t l) = do
    tempID <- runDB $ insert $ Temperature d t l
    return () 

getDate :: Temperature -> Maybe UTCTime
getDate (Temperature d _ Nothing) = parseISO8601 d

myDate :: [Temperature] -> [Maybe UTCTime]
myDate [] = [Nothing]
myDate (x:xs) = getDate x : myDate xs 

-- fetch temperature data and store it, then 
getHomeR :: Handler Text
getHomeR = do
    _ <- lift (forkIO getAndStoreTemperatures)
    return "Hello World"

