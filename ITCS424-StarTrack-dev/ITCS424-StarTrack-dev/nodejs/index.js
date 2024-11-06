const app = require("./app");
const db = require('./db/mongodb.js')

const port = 3000;

app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})