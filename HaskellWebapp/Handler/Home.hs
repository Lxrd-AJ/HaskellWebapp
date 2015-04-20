module Handler.Home where

import Import
import qualified Network.HTTP as HP 
import Control.Applicative ()
import Control.Monad()
import qualified Data.ByteString.Lazy.Char8 as BS

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.   //defaultLayout $(widgetFile "home") (<$>), (<*>)
data Temperature = Temperature {
    date :: Text,
    temp :: Int
}

newtype Temperatures = Temperatures [Temperature]   

instance ToJSON Temperature where
    toJSON Temperature {..} = object 
        [ "date" .= date 
        , "temp" .= temp 
        ]

instance FromJSON Temperatures where
    parseJSON (Object o) = 
        Temperatures <$> (o .: "temperatures")
    parseJSON _          = mzero  


instance FromJSON Temperature where
     parseJSON (Object t) = Temperature <$>
                            t .: "date" <*>
                            t .: "temp"
     parseJSON _          = mzero

retrieveResponse :: IO String 
retrieveResponse = do 
    result <- HP.simpleHTTP (HP.getRequest "http://www.phoric.eu/temperature") 
    (HP.getResponseBody result) 

getHomeR :: Handler Value
getHomeR = do 
        result <-  lift $ HP.simpleHTTP (HP.getRequest "http://www.phoric.eu/temperature")
        json   <- lift $ (HP.getResponseBody result) 
        returnJson json


