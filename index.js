var express = require("express");
var app = express();

app.listen(process.env.PORT || 3000);

app.use(express.static(__dirname));
