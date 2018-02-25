import React, { Component } from 'react';
import logo from './Identity.png';
import './style.css';

class App extends Component {W
    render() {
        return (
            <div className="App">
                <div className="App-header">
                    <img src={logo} className="App-logo" alt="logo" />
                    <h2>Identity Manager</h2>
                </div>
                <div align="center" className="App-nav">

                    <form id="input" action="/action_page.php">
                        <table>
                            <tr>
                                <th>Public Key:  </th>
                                <th><input type="text" name="pubkey"></input></th>
                            </tr>
                            <tr>
                                <th>First name:  </th>
                                <th><input type="text" name="fname"></input></th>
                            </tr>
                            <tr>
                                <th>Last name: </th>

                                <th><input type="text" name="lname"></input></th>
                            </tr>
                            <tr>
                                <th> ID No.:  </th>
                                <th><input type="text" name="ID"></input></th>
                            </tr>
                            <tr>
                                <th> Nationality:</th>
                                <th> <input type="text" name="nationality"></input></th>
                            </tr>
                            <tr>
                                <th> Locality: </th>
                                <th> <input type="text" name="locality"></input></th>
                            </tr>
                            <tr>
                                <th> Sex: </th>
                                <th> <input type="text" name="sex"></input></th>
                            </tr>
                            <tr>
                                <th> Date of Birth: </th>
                                <th> <input placeholder="YYYY-MM-DD" type="text" name="dob"></input></th>
                            </tr>
                        </table>
                        <input id="submission" className="buttonSubmit" type="button" value="Create Identity"></input>
                    </form>

  <form id="revoke" className="revokeField" action="/action_page.php">
                        <table>
                            <tr>
                                <th>Revoke ID</th>
                                <th><input type="text" name="revID"></input></th>
                            </tr>
                        </table>
                        <input id="submissionRev" className="buttonSubmit" type="button" value="Revoke"></input>
                    </form>
                </div>
                <div className="App-header">
                    <p id='resultout'></p>
                </div>
            </div>
        );
    }
}

window.onload = function () {
    document.getElementById("submission").onclick = function fun() {
        
        //create identity
        exportToContract();
    }
    document.getElementById("submissionRev").onclick = function func() {    
        //revoke identity
    }
}

function exportToContract() {
    var Web3 = require('web3');
    var web3;

    if (!web3) {
//Connect to web3 instance
        web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
    }

       
    //Copy abi into a json file and put it somewhere within nodejs app folder somewhere
    //var abiJson = require('./Storage.json');
    //Copy your contract address here
    var contAddr = "0x708250e7f220348943749967695af385c2a43c05";
    var myAddr = "0x90c33e353b721ba0647ff07119e730edbc6d077b";
    
    
    var pkey = document.forms["input"]["pubkey"].value;
    var dateofbirth = document.forms["input"]["dob"].value;
    var fname = document.forms["input"]["fname"].value;
    var lname = document.forms["input"]["lname"].value;
    var ID = document.forms["input"]["ID"].value;
    var nationality = document.forms["input"]["nationality"].value;
    var locality = document.forms["input"]["locality"].value;
    var sex = document.forms["input"]["sex"].value;

    if (!(fname != null && lname != null && nationality != null && locality != null && sex != null)) {
        alert("Fields must be filled out");
        return false;
    }

    var gender;
    if(sex === 'male')
        gender = 0;
        else if (sex==='female')
        gender = 1;
        else
        gender =2;

    var identityFactory = new web3.eth.Contract([{"constant":false,"inputs":[],"name":"createObject","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newAuth","type":"address"}],"name":"removeAuthorizationFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newAuth","type":"address"}],"name":"giveAuthorizationTo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"changeOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"legacyId","type":"string"}],"name":"lookupIdentity","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"legacyId","type":"string"},{"name":"name","type":"string"},{"name":"surname","type":"string"},{"name":"locality","type":"string"},{"name":"nationality","type":"string"},{"name":"dateOfBirth","type":"uint256"},{"name":"gender","type":"uint8"}],"name":"setID","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]);
    //var identity = new web3.eth.Contract([{"constant":false,"inputs":[],"name":"createObject","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newAuth","type":"address"}],"name":"removeAuthorizationFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newAuth","type":"address"}],"name":"giveAuthorizationTo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"changeOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"legacyId","type":"string"}],"name":"lookupIdentity","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"owner","type":"address"},{"name":"legacyId","type":"string"},{"name":"name","type":"string"},{"name":"surname","type":"string"},{"name":"locality","type":"string"},{"name":"nationality","type":"string"},{"name":"dateOfBirth","type":"uint256"},{"name":"gender","type":"uint8"}],"name":"setID","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]);
    
    identityFactory.options.address =contAddr;

    identityFactory.methods.setID(pkey, ID,fname,lname,locality,nationality,dateToUnix(dateofbirth),gender).send({from: myAddr}).then(result=>{
    //var output = identityFactory.methods.get().call().then(console.log);
    //console.log(output);
   })
   var objectID = identityFactory.methods.createObject().send({from: myAddr}).then(function(i){console.log(i); return i});



   var certificate = objectID.methods.generateRevocationCertificate().call().then(function(i){console.log(i); return i});
   var output = "Identity generated. Revocation ID: " + certificate + ". Address = "+ objectID;
   
   var paragraph = document.getElementById("resultout");

paragraph.appendChild(output);

//do contractref.[func] of smart contract
}
export default App;

function dateToUnix(dateStr){
    const dateTime = new Date(dateStr).getTime();
    const timestamp = Math.floor(dateTime / 1000);
    return timestamp;
}