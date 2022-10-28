const mongoose = require('mongoose');
var Schema = mongoose.Schema;

var heroesSchema = Schema({
    IdCharacter: String,
    Charname: String,
    Birthname: String,
    Birthplace: String,
    Religion: String,
    Gender: String,
    Superpowers: String,
    Categories: String,
    Universes: String,
    Teams: String,
    Occupation: String
});
module.exports = mongoose.model('Characters', heroesSchema);
