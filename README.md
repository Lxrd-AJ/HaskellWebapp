# HaskellWebapp  [![Build Status](https://travis-ci.org/Lxrd-AJ/HaskellWebapp.svg?branch=master)](https://travis-ci.org/Lxrd-AJ/HaskellWebapp)
## CI285 Functional Programming in Haskell Web Application using Yesod
The approach taken by the programmer 😎😎, is to separate the front end & backend into 2 separate concerns.
As a result, the both client server communicate using HTTP & JSON. 

The Project structre is broken down into 2 directories
* HaskellWebapp
* Ronin

### HaskellWebapp
This is where all the Server side code resides and the server should be run from here.
The project uses MySQLite as the persistent store, which if does not exist would automatically be created.
All the RESTful compliant routes are defined in the `config/routes` file
### Ronin
This contains the EmberJS webapp development code. The built webapp is also located in HaskellWebapp/static/webapp
**The webapp makes ajax requests to the server on the localhost on port 3000**

___
#### Development
To run the server, run the following commands
``` 
cd HaskellWebapp
yesod devel
```
#### Production
To build an executable/compile the project, run the following commands
```
cd HaskellWebapp
cabal clean
cabal configure
cabal build
```
The executable is then available at `HaskellWebapp/dist/HaskellWebapp/HaskellWebapp` .
To deploy it on a live server, just upload
1. The executable
2. The entire `config/*` folder
3. The entire `static/*` folder


