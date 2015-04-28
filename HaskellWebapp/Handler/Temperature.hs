module Handler.Temperature where

import Import
import Data.Aeson 

getTemperatureR :: Handler Value
getTemperatureR = do 
	tempID <- runDB $ insert $ Temperature "2015-02-28T20:16:12+00:00" 43 Nothing --TODO: Remove later
	temperatures <- runDB $ selectList [] [Asc TemperatureId] -- Get all temperature data from DB
	returnJson temperatures      -- Return the JSON 
