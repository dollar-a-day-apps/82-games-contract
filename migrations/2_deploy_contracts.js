var SafeMath = artifacts.require("SafeMath");
var Game82Token = artifacts.require("Game82Token");
var Game82 = artifacts.require("Game82");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Game82Token);
  deployer.deploy(Game82);
}
