const path = require('path')
const dotenv = require('dotenv')
const express = require('express')
const bodyParser = require('body-parser')
const sessions = require('express-session');
const cookieParser = require("cookie-parser");
const app = express()
dotenv.config()
const mysql = require('mysql2');

var connection = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USERNAME,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE
})

connection.connect(function (err) {
    if (err) throw err;
    console.log(`Connected DB: ${process.env.MYSQL_DATABASE}`);
})

const router = express.Router()
app.use(bodyParser.urlencoded({extended:true}))

router.use(bodyParser.json())
app.use(sessions({
    secret: "secret",
    saveUninitialized: true,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24
    }, // Set cookie's age to 1 day
    resave: false
}))

app.set('views', path.join(__dirname, '../html/views'))
app.engine('html', require('ejs').renderFile)
app.set('view engine', 'ejs')
app.use(cookieParser());
app.use(express.static('public'))
app.use('/', router)

router.get(['/', '/home'], (req, res) => {
    res.sendFile('html/index.html', {
        root: 'public'
    })
})

router.get('/products', (req, res) => {
    res.sendFile('html/Products.html', {
        root: 'public'
    })
})

router.get('/products-manage', (req, res) => {
    res.sendFile('html/PSM.html', {
        root: 'public'
    })
})

router.get('/product-manage', (req, res) => {
    session = req.session
    if (session.userid) return res.sendFile('html/Admin_pro.html', {
        root: 'public'
    })

    res.sendFile('html/views/Access_denied.html', {root: "public"})
})

router.get('/user-manage', (req, res) => {
    session = req.session
    if (session.userid) return res.sendFile('html/Admin_user.html', {
        root: 'public'
    })

    res.sendFile('html/views/Access_denied.html', {root: 'public'})
})

router.get('/search', (req, res) => {
    res.sendFile('html/Search.html', {
        root: 'public'
    })
})

router.get('/aboutus', (req, res) => {
    res.sendFile('html/AboutUs.html', {
        root: 'public'
    })
})

router.get('/login', (req, res) => {
    res.sendFile('html/login.html', {
        root: 'public'
    })

})

router.get('/products/product_Costa_Rican', (req,res) => {
    res.sendFile('html/products/product_Costa_Rican.html', {
        root: 'public'
    })
})

router.get('/products/product_Guatemalan', (req,res) => {
    res.sendFile('html/products/product_Guatemalan.html', {
        root: 'public'
    })
})

router.get('/products/product_Nicaraguan', (req,res) => {
    res.sendFile('html/products/product_Nicaraguan.html', {
        root: 'public'
    })
})

router.get('/products/product_Signature', (req,res) => {
    res.sendFile('html/products/product_Signature.html', {
        root: 'public'
    })
})

router.get('/products/product_Victorious', (req,res) => {
    res.sendFile('html/products/product_Victorious.html', {
        root: 'public'
    })
})

router.post('/loginsuccess', function (req, res) {
    query = req.body

    let sql = `SELECT * FROM admin_info WHERE username = '${query.username}' AND password = '${query.password}'`

    connection.query(sql, function (error, data) {
        if (error) return res.sendFile('html/login.html', {
            root: 'public'
        }) //console.log(error)

        session = req.session
        session.userid = query.username
        return res.redirect('/manage')
    })

})

router.get('/location', function(req,res){
    res.sendFile('html/Map.html', {
        root: 'public'
    })
})

router.get('/manage', (req, res) => {
    session = req.session
    if(session.userid) return res.sendFile('html/admin_user.html', {
        root: 'public'
    })

    res.sendFile('html/views/Access_denied.html', {root: 'public'})
})

/*----------POSTMAN-----------*/

/*----------INSERT------------*/
/*
Method: POST
URL: localhost:3030/admin
body: raw JSON
{
    "admin_info":{
        "admin_id": "179",
        "username": "test2",
        "password": "1234",
        "role": "test",
        "login_log": "test"     
    }
}
*/
router.post('/admin', function (req, res) {
    let data = req.body.admin_info

    if (!data) return res.status(400).send({
        error: true,
        message: 'err'
    });

    connection.query(`INSERT INTO admin_info SET ?`, data, function (error, results) {
        if (error) throw error
        return res.send({
            log: results,
            data: data
        })
    })
})

/*--------------UPDATE----------------*/
/*
Method: PUT
URL: localhost:3030/admin
body: raw JSON
{
    "admin_info":{
        "admin_id": "179",
        "username": "test99",
        "password": "test99_1234",
        "role": "ADMIN",
        "login_log": "WELCOME"     
    }
}
*/
router.put('/admin', function (req, res) {
    let admin_id = req.body.admin_info.admin_id
    let data = req.body.admin_info
    console.log(data)

    if (!data || !admin_id) return res.send({
        err: data
    })

    connection.query(`UPDATE admin_info SET ? WHERE admin_id = ?`, [data, admin_id], function (error, results) {
        if (error) throw error
        return res.send({
            log: results.info,
            data: data
        })
    })
})

router.get('/admin', function (req, res) {
    connection.query(`SELECT * FROM admin_info`, function (error, results) {
        if (error) throw error
        return res.send({
            data: results
        })
    })
})

router.delete('/admin', function (req, res) {
    let admin_id = req.body.admin_info.admin_id
    let data = req.body.admin_info

    if (!admin_id || !data) return res.send({
        message: `Admin's ID not found or not exist.`
    })

    connection.query('DELETE FROM admin_info WHERE admin_id = ?', admin_id, function (error, results) {
        if (error) throw error
        return res.send({
            log: results,
            data: data
        })
    })
})
/*********************************************************************************************************/

/*---------------ADMIN MANAGEMENTs-------------------------*/
router.get('/output', function (req, res) {
    return res.sendFile('html/views/Admin_output.html', {
        root: 'public'
    })
})
//Admin functions
router.post('/submit', function(req, res) {
    const query = req.body
    let data = req.body.administrator
    const butt_selected = req.body.buttons
  
    let id = query.admin_id
    let fname = query.first_name
    let lname = query.last_name
    let address = query.address
    let age = query.age
    let gender = query.gender
    let email = query.email

    data = {
        "admin_id": id,
        "firstname": fname,
        "lastname": lname,
        "address": address,
        "age": age,
        "sex": gender,
        "email": email
    }

    let count = 0
    Object.values(query).forEach(e => {
        if (e == "") count++
    });

    if (butt_selected == 'Search') {
        let cID = query._admin_id
        let cAddress = query._address
        let cGender = query._gender

        console.log([cID,cAddress,cGender])

        let sql = "SELECT * FROM administrator WHERE ";
        let queryParams = [];

        if (cID) {
            console.log(cID)
            sql += "admin_id = ? AND ";
            queryParams.push(cID);
        }

        if (cAddress) {
            sql += "address LIKE ? AND ";
            queryParams.push('%' + cAddress + '%');
        }

        if (cGender) {
            sql += "sex = ? AND ";
            queryParams.push(cGender);
        }

        console.log(queryParams)
        // remove the trailing "AND"
        sql = sql.slice(0, -5);

        // execute the query with the parameters
        connection.query(sql, queryParams, function(err, results, fields) {
            if (err) throw err;
            return res.render('Admin_output', {
                action: 'sNoCriteria',
                data: results
            })
            
        });
    }

    if (butt_selected == "Delete") {
        if(id)
        {
            connection.query(`DELETE FROM administrator WHERE admin_id = ?`, id, function(err,results){
                if(err) throw err

                console.log(`LOG: DELETED SUCCESSFULLY.`)
            })
        }
        
    }

    if(butt_selected == "Update"){
        if(!count)
        {
            connection.query(`UPDATE administrator SET ? WHERE admin_id = ?`, [data, id], function(err,results){
                if(err) throw err

                console.log(`LOG: UPDATE SUCCESSFULLY.`)    
            })
        }
    }

    if (butt_selected == 'Add') {
        connection.query(`INSERT INTO administrator SET ?`, data, function (err, results) {
            if (err) throw err

            console.log(`LOG: ADDED SUCCESSFULLY.\n${[results, data]}`)
        })
    }
})
/*--------------------------------------------------------------------*/

/*---------------------------PRODUCTS MANAGEMENT---------------------------------*/

router.post('/edit/product', function(req,res){
    const query = req.body
    let data = req.body.product_data
    const butt_selected = query.buttons

    data = {
        "product_id": query.product_id,
        "product_name": query.product_name,
        "product_info": query.product_info,
        "product_price": query.product_price,
    }

    let count = 0
    Object.values(query).forEach(e => {
        if (e == "") count++
    });
    
    if(butt_selected == 'Add')
    {
        if(count == 0){
          connection.query(`INSERT INTO product_data SET ?`, data, function (err, results) {
            if(err) throw err

            console.log(`LOG: ADDED SUCCESSFULLY.\n${[results, data]}`)
        })  
        }
        
        if(count > 0) console.log(`LOG: PLEASE INSERT ALL DATA IN THE FIELDS`)
        
    }

    if(butt_selected == 'Delete')
    {
        if(query.product_id)
        {
            connection.query(`DELETE FROM product_data WHERE product_id = ?`, query.product_id, function(err,results){
                if(err) throw err

                console.log(`LOG: DELETED SUCCESSFULLY.`)
            })
        }

        if(!query.product_id) console.log(`LOG: PLEASE ENTER PRODUCT ID TO DELETE`)
    }

    if(butt_selected == 'Update')
    {
        if(query.product_id)
        {
            connection.query(`UPDATE product_data SET ? WHERE product_id = ?`, [data, query.product_id], function(err,results){
                if(err) throw err

                console.log(`LOG: UPDATE SUCCESSFULLY.`)    
            })
        }

        if(!query.product_id) console.log(`LOG: PLEASE ENTER PRODUCT ID TO UPDATE DATA`)
    }
})

router.post('/Search', function(req, res) {
    const query = req.body
    let data = req.body.product_data
    const butt_selected = req.body.buttons

    let id = query.product_id
    let pname = query.product_name
    let pinfo = query.product_info
    let pprice = query.product_price

    data = {
        "product_id": id,
        "product_name": pname,
        "product_info": pinfo,
        "product_price": pprice,
    }

    let count = 0
    Object.values(query).forEach(e => {
        if (e == "") count++
    });

    if (butt_selected == 'Submit') {
        let pName = query.name_
        let pCountry = query.country
        let pPrice = query.price

        let sql = "SELECT * FROM product_data WHERE ";
        let queryParams = [];

        if (pName) {
            sql += "product_name LIKE ? AND ";
            queryParams.push('%' + pName + '%');
        }

        if (pCountry) {
            if(pCountry == 'all') return sql += "";
            
            if(pCountry == 'Africa')
            {
                sql += "product_info = ? AND ";
                queryParams.push(pCountry);  
            } 

            if(pCountry == 'Thailand')
            {
                sql += "product_info = ? AND ";
                queryParams.push(pCountry);  
            }

            if(pCountry == 'England')
            {
                sql += "product_info = ? AND ";
                queryParams.push(pCountry);  
            }
        }

        if (pPrice) {
            if(pPrice == 'all') return sql += "";
          
            if(pPrice == '12.99')
            {
                sql += "product_price = ? AND ";
                queryParams.push(pPrice);  
            }
            
            if(pPrice == '13.99')
            {
                sql += "product_price = ? AND ";
                queryParams.push(pPrice);  
            }

            if(pPrice == '14.99')
            {
                sql += "product_price = ? AND ";
                queryParams.push(pPrice);  
            }

            if(pPrice == '15.99')
            {
                sql += "product_price = ? AND ";
                queryParams.push(pPrice);  
            }
            
        }

        console.log(queryParams)
        // remove the trailing "AND"
        sql = sql.slice(0, -5);
        console.log(sql)
        // execute the query with the parameters
        connection.query(sql, queryParams, function(err, results, fields) {
            if (err) throw err;

            return res.render('Search', {
                action: 'sNoCriteria',
                data: results
            })

        });

     } 
});

app.listen(process.env.PORT, function () {
    console.log(`Listening to port ${process.env.PORT}`)
})