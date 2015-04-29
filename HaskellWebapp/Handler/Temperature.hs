module Handler.Temperature where

import Import
import Data.Aeson 

getTemperatureR :: Handler Value
getTemperatureR = do 
	temperatures <- runDB $ selectList [] [Asc TemperatureId] -- Get all temperature data from DB
	returnJson temperatures      -- Return the JSON 

-- Get all the temperature data for a particular location
getUserTemperatureR :: LocationId -> Handler Value
getUserTemperatureR locationID = do 
	temps <- runDB $ selectList [TemperatureLocation ==. (Just locationID)] []
	returnJson temps