  var Web3 = require('web3');
    var myBcInstance;

    exports.myBcConnection  = function() {
        if (myBcInstance) {
            return myBcInstance;
        } else {
//Connect to web3 instance
            myBcInstance = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
            return myBcInstance;
        }
    };
