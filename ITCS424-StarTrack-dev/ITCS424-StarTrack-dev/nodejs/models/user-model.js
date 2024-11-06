const db = require('../db/mongodb')
const bcrypt = require('bcrypt')
const mongoose = require('mongoose')
const { Schema } = mongoose

const userSchema = new Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  email: { type: String, required: true },
  uid: { type: String, required: true },
  cookie: { type: String, required: true },

}, { 
    timestamps: true 
})

/*
 * Hash the password before saving it to the database
 */
userSchema.pre("save",async function(){
    var user = this
    if(!user.isModified("password")){
        return
    }
    try{
        const salt = await bcrypt.genSalt(10)
        const hash = await bcrypt.hash(user.password,salt)
        user.password = hash
    }catch(err){
        throw err
    }
})

userSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        console.log('----------------no password',this.password)
        // @ts-ignore
        const isMatch = await bcrypt.compare(candidatePassword, this.password)
        return isMatch
    } catch (error) {
        throw error
    }
}

const UserModel = db.model('user',userSchema);
module.exports = UserModel