const Products = artifacts.require("Products");
const Ratings = artifacts.require("Ratings");

module.exports = function (deployer) {
  deployer.deploy(Products);
  deployer.deploy(Ratings);
};
