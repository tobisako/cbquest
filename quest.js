const express = require('express');
const bodyParser = require("body-parser")
const app = express();
app.use(bodyParser.json());
app.use("/", express.static(__dirname + '/'));
app.get('/', (req, res) => { res.redirect("/cbquest.html"); });

app.listen(3000, () => {
    console.log('listen 3000');
});
