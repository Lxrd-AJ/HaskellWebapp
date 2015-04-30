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

 
-- fetch temperature data and store it, then 
getHomeR :: Handler TypedContent
getHomeR = do
    decoded <- eitherDecode <$> (simpleHttp $ "http://www.phoric.eu/temperature") 
    case decoded of 
        Right result -> (storeTemperatures (temperatures result))
        Left _ -> sendFile "text" "Failed" -- If an error occurred, fail silently and return  
    where 
    	storeTemperatures [] = sendFile "text/html" "static/webapp/index.html"      -- return the EmberJS webapp
    	storeTemperatures (x:xs) = do 
    		_ <- runDB $ insert x 
    		storeTemperatures xs 


