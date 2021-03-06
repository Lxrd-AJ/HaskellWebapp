module Handler.Location where

import Import

-- Get all the Location for a particular user
getLocationR :: UserId -> Handler Value
getLocationR userId = do
	addHeader "Access-Control-Allow-Origin" "*"
	locations <- runDB $ selectList [LocationUserId ==. userId] []
	returnJson locations
