module Handler.Temperature where

import Import
import Data.Aeson 

-- Get all temperature data from DB
getTemperatureR :: Handler Value
getTemperatureR = do 
	addHeader "Access-Control-Allow-Origin" "*"
	temperatures <- runDB $ selectList [] [Asc TemperatureId] 
	returnJson temperatures      -- Return the JSON 

-- Get all the temperature data for a particular location
getUserTemperatureR :: LocationId -> Handler Value
getUserTemperatureR locationID = do 
	temps <- runDB $ selectList [TemperatureLocation ==. (Just locationID)] []
	returnJson temps