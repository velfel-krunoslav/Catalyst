const Products = artifacts.require("Products");
const Ratings = artifacts.require("Ratings");
const Categories = artifacts.require("Categories");

module.exports = function (deployer) {
  deployer.deploy(Products);
  deployer.deploy(Ratings);
  deployer.deploy(Categories);
};
