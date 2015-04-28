module Handler.Stats where

import Import
import Data.Time.ISO8601 -- [docs] := https://hackage.haskell.org/package/iso8601-time-0.1.3/docs/Data-Time-ISO8601.html
import Data.Time.Clock (UTCTime)
--import Data.Number.RealToFrac 
import qualified Data.List as L 

{-  😪😪 didnt end up using these functions, oh well, life goes on
getDate :: Temperature -> Maybe UTCTime
getDate (Temperature d _ Nothing) = parseISO8601 d
getDate _ = Nothing

myDate :: [Temperature] -> [Maybe UTCTime]
myDate [] = [Nothing]
myDate (x:xs) = getDate x : myDate xs
-}

temperature :: Temperature -> Int
temperature (Temperature _ temp _) = temp

stripEntity :: Entity Temperature -> Temperature
stripEntity (Entity _ temp) = temp

stripEntities :: [Entity Temperature] -> [Temperature]
stripEntities [] = []
stripEntities (x:xs) = stripEntity x : stripEntities xs 

-- Get all temp data 
-- Perform some processing & return a few Stats 
getStatsR :: Handler Value
getStatsR = do 
	temps <- runDB $ selectList ([] :: [Filter Temperature]) []
	returnJson $ object 
		[ "sum" .= getSum (stripEntities temps) ,
		  "total" .= (length temps) ,
		  "test" .= ("I was runnning through the 6 with my woes" :: Text) ,
		  "highest" .= getHottest (stripEntities temps) ,
		  "lowest" .= getCoolest (stripEntities temps) ,
		  "average" .= getAverage (stripEntities temps) 
		]

getSum :: [Temperature] -> Int 
getSum [] = 0
getSum (x:xs) = (temperature x) + getSum xs

getHottest :: [Temperature] -> Temperature
--getHottest ls = maximum ls --FIXME: Bug here, santa mariá would you work!!
getHottest [] = error "Cannot work on an empty list"    -- getHottest xs = maximum . stripEntities xs
getHottest [x] = x 
getHottest (x:xs) = max x (getHottest xs)

getCoolest :: [Temperature] -> Temperature
getCoolest [] = error "Cannot work on an empty list"
getCoolest [x] = x
getCoolest (x:xs) = min x (getCoolest xs) 

getAverage :: [Temperature] -> Float
getAverage [] = 0 
getAverage xs = ( L.foldl ( \acc temp -> acc + (realToFrac $ temperature $ temp) ) 0 xs ) / (L.genericLength xs) 
