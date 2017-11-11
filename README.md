# Elm 0.18 with Webpack 3, Hot Loading & Bootstrap 4-beta

Elm dev environment with hot-loading (i.e. state is retained as you edit your code - Hot Module Reloading, HMR)). I use this daily for my professional work. Like elm-community/elm-webpack-starter but using Webpack 3.

### Meetup auth

(This manual step is needed to get data from Meetup)

Click [here](
https://secure.meetup.com/oauth2/authorize?client_id=nsslb8dhan5tm2sklc33rdt6e2&response_type=token&redirect_uri=http://localhost:3000)

Authorise the app, and then copy the token in the redirect
http://localhost:3000/#access_token=**c2551192279670d376393d33b88a16bc**&token_type=bearer&expires_in=3600

to line 12 of the app


## Installation

Clone this repo into a new project folder and run install script.
(I ignore the errors about missing jquery as it is best not to use the Bootstrap jquery-based components with Elm)

With npm

```sh
$ git clone git@github.com:simonh1000/elm-webpack-starter.git new-project
$ cd new-project
$ npm install
$ npm run dev
```

With yarn
```sh
$ git clone git@github.com:simonh1000/elm-webpack-starter.git new-project
$ cd new-project
$ yarn
$ yarn dev
 ```

Open http://localhost:3000 and start modifying the code in /src.
(An example using Routing is provided in the `navigation` branch)
