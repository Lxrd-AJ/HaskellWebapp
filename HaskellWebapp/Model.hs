module Model where

import ClassyPrelude.Yesod
import Database.Persist.Quasi

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

data Temperatures = Temperatures {
    temperatures :: [Temperature]
} deriving (Show,Generic)

instance FromJSON Temperatures    
instance ToJSON Temperatures

-- NB: For the current context, we simply use ONLY temperature values while ignoring dates for comparison
instance Eq Temperature where
	(Temperature _ x _) == (Temperature _ y _) = x == y  
	(Temperature _ x _) /= (Temperature _ y _) = not (x == y)

instance Ord Temperature where
  	compare (Temperature _ x _) (Temperature _ y _) = compare x y 


