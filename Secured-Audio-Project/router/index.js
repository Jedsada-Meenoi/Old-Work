const express = require('express');
const cryptoJS = require('crypto-js');
const AES = require('crypto-js/aes');
const fs = require('fs');
const formidable = require('formidable');

const router = express.Router();

let password = ''; // Store the password in memory
let encryptedChunks = []; // Store encrypted chunks
let decryptedChunks = ''; // Store decrypted chunks

router.get('/', (req, res) => {
    res.render('index.html');
});

// POST endpoint for receiving the user's password
router.post('/password', (req, res) => {
    password = req.body.password;
    res.send('Password received successfully.');
});

// POST endpoint for encrypting a file
router.post('/encrypt', (req, res) => {
    encryptedChunks = []; // Clear previous encrypted chunks
    const form = new formidable.IncomingForm();

    form.parse(req, (err, fields, files) => {
        if (err) {
            console.error('Formidable parsing error:', err);
            res.status(500).send('Formidable parsing failed.');
            return;
        }

        // Process each file
        Object.values(files).forEach(file => {
            if (file[0] && file[0].filepath) {
                const fileObj = fs.readFileSync(file[0].filepath);
                const base64obj = fileObj.toString('base64');
                const middle = Math.floor(base64obj.length / 2);
                const s1 = base64obj.substr(0, middle);
                const s2 = base64obj.substr(middle);

                // Encrypt asynchronously
                async function encrypt() {
                    const encr1 = AES.encrypt(s1, password).toString();
                    const encr2 = AES.encrypt(s2, password).toString();
                    encryptedChunks.push(encr1, encr2);
                }

                // Encrypt and handle result
                encrypt().then(() => {
                    console.log('POST /encrypt server: ' + encryptedChunks.join('').length);
                    res.send('passed');
                }).catch(error => {
                    console.error('Encryption error:', error);
                    res.status(500).send('Encryption failed.');
                });
            } else {
                console.error('Invalid file object:', file);
                res.status(400).send('Invalid file object received.');
                return;
            }
        });
    });
});

// GET endpoint for retrieving the encrypted file
router.get('/getEncrypt', (req, res) => {
    res.send(encryptedChunks.join(''));
});

// POST endpoint for decrypting a file
router.post('/decrypt', (req, res) => {
    decryptedChunks = ''; // Clear previous decrypted chunks
    const form = new formidable.IncomingForm();
    form.parse(req, (err, fields, files) => {
        if (err) {
            console.error('Formidable parsing error:', err);
            res.status(500).send('Formidable parsing failed.');
            return;
        }

        Object.values(files).forEach(file => {
            if (file[0] && file[0].filepath) {
                const fileObj = fs.readFileSync(file[0].filepath);
                const str = fileObj.toString();
                const middle = Math.floor(str.length / 2);
                const s1 = str.substr(0, middle);
                const s2 = str.substr(middle);
                async function decrypt() {
                    const dec1 = AES.decrypt(s1, password).toString(cryptoJS.enc.Utf8);
                    const dec2 = AES.decrypt(s2, password).toString(cryptoJS.enc.Utf8);

                    decryptedChunks = dec1 + dec2

                    return decryptedChunks
                }
                decrypt().then(() => {
                    console.log('POST /decrypt server: ' + decryptedChunks.length);
                    res.send('passed');
                }).catch(error => {
                    console.error('Decryption error:', error);
                    res.status(500).send('Decryption failed.');
                });
            } else {
                console.error('Invalid file object:', file);
                res.status(400).send('Invalid file object received.');
                return;
            }
        });

    });
        
});

// GET endpoint for retrieving the decrypted file
router.get('/getDecrypt', (req, res) => {
    const buff = Buffer.from(decryptedChunks, 'base64');
    res.send(buff);
});

module.exports = router;