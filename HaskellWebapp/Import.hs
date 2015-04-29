module Import
    ( module Import
    ) where

import Foundation            as Import
import Import.NoFoundation   as Import
import Data.Aeson.Types
import qualified Data.Text as T

stripEntity :: Entity a -> a
stripEntity (Entity _ temp) = temp

stripEntities :: [Entity a] -> [a]
stripEntities [] = []
stripEntities (x:xs) = stripEntity x : stripEntities xs 