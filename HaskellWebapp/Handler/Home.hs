module Handler.Home where

import Import
import Control.Applicative()
import Control.Monad()
--import qualified Data.ByteString.Lazy.Char8() 
import qualified Data.Text as T 
import qualified Data.ByteString.Lazy as BS 
import Control.Monad (when)
import Data.Aeson
import GHC.Generics()
import Network.HTTP.Conduit( simpleHttp )
--import qualified Data.List as LS
import Data.Maybe
import qualified Data.Text as T 

getJSON :: IO BS.ByteString
getJSON = simpleHttp $ "http://www.phoric.eu/temperature" -- unsafeperformio

{-
unwrapTemperatures :: Temperatures -> [Temperature]
unwrapTemperatures ts = temperatures ts -- (Temperatures {temperatures = xs})
-}

getAndStoreTemperatures :: IO [Handler (Key Temperature)]   
getAndStoreTemperatures = do  
        decoded <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
        case decoded of 
            Right result -> do 
                return $ storeTemperatures result
            Left _ -> return $ [] -- If an error occurred, fail silently and return

storeTemperatures :: Temperatures -> [Handler (Key Temperature)]
storeTemperatures temps = do -- map storeTemperature (unwrapTemperatures temps)
	res <- temperatures temps -- unwrapTemperatures temps
	map storeTemperature [res] -- FIXME Not working   [storeTemperature tmp | tmp <- res]
    
storeTemperature :: Temperature -> Handler (Key Temperature)
storeTemperature (Temperature d t l) = runDB $ insert $ Temperature d t l

-- fetch temperature data and store it, then 
getHomeR :: Handler TypedContent
getHomeR = do
    _ <- lift getAndStoreTemperatures                    -- Get the response & Store it in the database
    sendFile "text/html" "static/webapp/index.html"      -- return the EmberJS webapp


