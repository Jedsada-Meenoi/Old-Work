var express = require('express');
var path = require('path');
var routes = require('./router/');
var app = express();


app.use(express.static(__dirname + '/assets'));


app.set('views', path.join(__dirname, 'home'));

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

// Use the routes defined in the 'router' directory
app.use('/', routes);

// Error handling middleware
app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
});

const port = process.env.PORT || 3030;

app.listen(port, function() {
    console.log('App is running on port ' + port);
});
