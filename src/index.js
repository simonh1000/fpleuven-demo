'use strict';

let token = "94df793965f578b10fedaede24fe0383";

// require('./index.html');
require('bootstrap-loader');
require("./styles.scss");

// var Elm = require('./Main');
// var app = Elm.Main.fullscreen(token);

var Elm = require('./Demo');
var app = Elm.Demo.fullscreen(token);
