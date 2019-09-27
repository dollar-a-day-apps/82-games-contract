var SafeMath = artifacts.require("SafeMath");
var Game82Token = artifacts.require("Game82Token");
var Game82 = artifacts.require("Game82");

module.exports = function(deployer, network, accounts) {
  var insToken;
  var insPay;

  deployer.deploy(SafeMath).then(function() {
    return deployer.deploy(Game82Token).then(function() {
      return Game82Token.deployed();
    }).then(function(ins) {
      insToken = ins;
      console.log("==Game82Token==:" + Game82Token.address.toString());

      return deployer.deploy(Game82);
    }).then(function() {
      return Game82.deployed(); 
    }).then(function(ins) {
      insPay = ins;
      console.log("==Game82==:" + Game82.address.toString()); 

      return deployer.link(SafeMath, Game82);
    });
  }); 
}
