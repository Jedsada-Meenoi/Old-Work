const mongoose = require('mongoose')

const connection = mongoose.createConnection(`mongodb://127.0.0.1:27017/StarTrack`)

connection.on('open', () => {
    console.log(`MongoDB: ${connection.name} connected`)
})

connection.on('error', () => {
    console.log("MongoDB: Connection error")
})

module.exports = connection;