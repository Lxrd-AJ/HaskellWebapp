module Handler.Temperature where

import Import
import Data.Aeson 

getTemperatureR :: Handler Value
getTemperatureR = do 
	_ <- runDB $ insert $ Temperature "2015-02-28T20:16:12+00:00" 5 Nothing --TODO: Remove later
	temperatures <- runDB $ selectList [] [Asc TemperatureId] -- Get all temperature data from DB
	returnJson temperatures      -- Return the JSON 

-- Get all the temperature data for a particular location
getUserTemperatureR :: LocationId -> Handler Value
getUserTemperatureR locationID = do 
	temps <- runDB $ selectList [TemperatureLocation ==. (Just locationID)] []
	returnJson temps