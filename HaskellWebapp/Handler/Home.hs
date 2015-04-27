module Handler.Home where

import Import
import Control.Applicative
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
import Network.Wai ( responseFile )
import Yesod.Static
-- /
-- Get the response
-- Store it in the database( fork a thread to do this )
-- return the EmberJS webapp

--staticFiles "static/webapp"

getJSON :: IO BS.ByteString
getJSON = simpleHttp $ "http://www.phoric.eu/temperature" -- unsafeperformio

unwrapTemperatures :: Temperatures -> [Temperature]
unwrapTemperatures (Temperatures {temperatures = xs}) = xs 

getAndStoreTemperatures :: IO [Handler (Key Temperature)]   
getAndStoreTemperatures = do  
        decoded <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
        case decoded of 
            Right result -> do 
                return $ storeTemperatures result
            Left _ -> return $ [] -- If an error occurred, return

storeTemperatures :: Temperatures -> [Handler (Key Temperature)]
storeTemperatures temps = map storeTemperature (unwrapTemperatures temps)
    
storeTemperature :: Temperature -> Handler (Key Temperature)
storeTemperature (Temperature d t l) = runDB $ insert $ Temperature d t l

getDate :: Temperature -> Maybe UTCTime
getDate (Temperature d _ Nothing) = parseISO8601 d

myDate :: [Temperature] -> [Maybe UTCTime]
myDate [] = [Nothing]
myDate (x:xs) = getDate x : myDate xs 

-- fetch temperature data and store it, then 
getHomeR :: Handler TypedContent
getHomeR = do
    _ <- lift getAndStoreTemperatures
    sendFile "text/html" "static/webapp/index.html"
    -- defaultLayout $(widgetFile "home")

