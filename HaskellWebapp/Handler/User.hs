module Handler.User where

import Import

getUserR :: Handler Html
getUserR = error "Not yet implemented: getUserR"

-- Create a new user supply { username, password }
postUserR :: Handler Value
postUserR = returnJson ("ok" :: Text)
