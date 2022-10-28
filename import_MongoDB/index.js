const mongoose = require('mongoose');
const mongoModel = require('./Mongo.model');
require('dotenv').config()

mongoose.Promise = global.Promise;
mongoose.connect(process.env.LOCAL, { useNewUrlParser: true, useUnifiedTopology: true }).then(() => {
    console.log("Se encuentra conectado a la base de datos de MongoDB");

    const sf = require('fs');
    const csv = require('csv-parser');

    var data = [];

    sf.createReadStream('C:/ProgramData/MySQL/dataMongo/Characters.csv')
        .pipe(csv({
            separator: ';',
            newline: '\n',
            headers: ['IdCharacter', 'Charname', 'Birthname', 'Birthplace', 'Religion', 'Gender', 'Superpowers',
                'Categories', 'Universes', 'Teams', 'Occupation'],
        }))
        .on('data', function (registros) {
            data.push(registros);
        })
        .on('end', function () {
            
            for (let n = 0; n < data.length; n++) {
                var modeloMongo = new mongoModel();

                modeloMongo.IdCharacter = data[n].IdCharacter;
                modeloMongo.Charname = data[n].Charname;
                modeloMongo.Birthname = data[n].Birthname;
                modeloMongo.Birthplace = data[n].Birthplace;
                modeloMongo.Religion = data[n].Religion;
                modeloMongo.Gender = data[n].Gender;
                modeloMongo.Superpowers = data[n].Superpowers;
                modeloMongo.Categories = data[n].Categories;
                modeloMongo.Universes = data[n].Universes;
                modeloMongo.Teams = data[n].Teams;
                modeloMongo.Occupation = data[n].Occupation;
             
                modeloMongo.save(function (error){
                    if (error) console.log(error);
                    else console.log('LOGRADO');
                });
            }

        });

}).catch(error => console.log(error));