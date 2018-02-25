var Identity = artifacts.require("./Identity.sol");
var IdentityFactory = artifacts.require("./IdentityFactory.sol");

var Qualifications = artifacts.require("./Qualifications.sol")
var QualificationsFactory = artifacts.require("./QualificationsFactory.sol");

var Factory = artifacts.require("./Factory.sol");
var IdentityModule = artifacts.require("./IdentityModule.sol");

module.exports = function(deployer) {
  deployer.deploy(IdentityFactory);
  deployer.deploy(QualificationsFactory);
};
