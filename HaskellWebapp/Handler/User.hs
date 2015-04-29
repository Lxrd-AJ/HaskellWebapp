module Handler.User where

import Import

-- return all users
getUserR :: Handler Value
getUserR = do 
	users <- runDB $ selectList ([] :: [Filter User]) []
	returnJson $ object [ "users" .= (stripEntities users) ]

-- GEt a particular user / Login a user
getLoginUserR :: Text -> Text -> Handler Value
getLoginUserR username password = do 
	addHeader "Access-Control-Allow-Origin" "*"
	probsUser <- runDB $ getBy $ UniqueUser username password
	case probsUser of 
		Nothing -> sendResponseStatus status500 ("USER_NOT_EXIST"::Text)
		Just (Entity uid user) -> returnJson $ object [ "userID" .= uid, "user" .= user ] 

-- Create a new user supply { username, password }
postLoginUserR :: Text -> Text -> Handler Value
postLoginUserR username password = do 
	userID <- runDB $ insert $ User username password
	returnJson $ object [ "userID" .= userID ]		


-- Enter a New location
postNewLocationR :: UserId -> Text -> Handler Value
postNewLocationR userID location = do 
	locationID <- runDB $ insert $ Location userID location
	returnJson $ object [ "locationID" .= locationID ]

-- Enter a New temperature data for a particular location
postNewTemperatureR :: UserId -> LocationId -> String -> Int -> Handler Value
postNewTemperatureR userID locationID tempDate tempVal = do 
	tempID <- runDB $ insert $ Temperature tempDate tempVal (Just locationID)
	returnJson $ object [ "temperatureID" .= tempID ]