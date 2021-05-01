const express = require('express');
const ipfsClient=require('ipfs-http-client');
const fs = require('fs');
const app = express();

var multer  = require('multer')
var upload = multer({ dest: 'uploads/' })
var ipfsAPI = require('ipfs-api')
//var ipfs = ipfsAPI('ipfs.infura.io', '5001', {protocol: 'https'})
const ipfs=new ipfsAPI({host:'localhost', port:'5001' ,protocol:'http'});
//npm install express --save
const addFile=async(fileName,filePath)=>{
    const file=new Buffer.from(fs.readFileSync(filePath));
    console.log(filePath);
    const fileAdded=await ipfs.add({path:fileName,content:file});
    const fileHash=fileAdded;
    console.log(fileHash)
    return fileHash;
}

app.get('/', function (req, res) {
    res.sendFile(__dirname+'/public/index.html');
})


app.post('/profile', upload.single('avatar'), async function (req, res, next) {
    var data = new Buffer.from(fs.readFileSync(req.file.path));
    ipfs.add(data, function (err,file){
        if(err){
            console.log(err);
        }
        console.log(file);
        res.send(file);
    })

  })

  app.get('/download/:ID',function(req,res){
      console.log(req.params.ID);
      res.redirect('https://ipfs.io/ipfs/'+req.params.ID);
  })
 
  app.listen(3000,()=>{
    console.log('Server is listening on port 3000');
});