{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (msum)
import Data.Char (toLower)
import Data.Maybe
import Network.HTTP
import System.IO
import Network.URI
import Happstack.Server( nullConf,simpleHTTP,ok,dir,seeOther,dirs, path, FromReqURI(..), Method(GET,POST,HEAD),method , methodM)
import Data.Aeson

data Temperature = Temperature
    { date :: String,
      value :: Double
    } deriving Show

instance FromJSON Temperature where
         fromJSON (Temperature date value) = object [ "date" .= date , "temperature" .= value ]

getJSONFromServer :: String -> Response
getJSONFromServer url =
    do
        response <- simpleHTTP req
        return $ response
        where req = Request {
            rqURI = uri ,
            rqMethod = GET ,
            rqHeaders = [],
            rqBody = ""
        }
              uri = fromJust $ parseURI url

jsonToTemperature :: Response -> [Temperature]
jsonToTemperature response = ok $ response

main :: IO()
main = simpleHTTP nullConf $ getJSONFromServer "http://www.phoric.eu/temperature"

