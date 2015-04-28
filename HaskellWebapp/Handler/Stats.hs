module Handler.Stats where

import Import
import Data.Time.ISO8601 -- [docs] := https://hackage.haskell.org/package/iso8601-time-0.1.3/docs/Data-Time-ISO8601.html
import Data.Time.Clock (UTCTime)

getDate :: Temperature -> Maybe UTCTime
getDate (Temperature d _ Nothing) = parseISO8601 d
getDate _ = Nothing

myDate :: [Temperature] -> [Maybe UTCTime]
myDate [] = [Nothing]
myDate (x:xs) = getDate x : myDate xs

--getAverage :: [Temperature] -> Int 

-- Get all temp data 
-- Perform some processing & return a few Stats 
getStatsR :: Handler Value
getStatsR = do 
	temps <- runDB $ selectList ([] :: [Filter Temperature]) []
	returnJson temps
