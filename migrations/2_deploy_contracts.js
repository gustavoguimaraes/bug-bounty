var LockYourEther = artifacts.require("./LockYourEther.sol");
var LockYourEtherBounty = artifacts.require("./LockYourEtherBounty.sol");

module.exports = function(deployer) {
  deployer.deploy(LockYourEther);
  deployer.deploy(LockYourEtherBounty);
};
