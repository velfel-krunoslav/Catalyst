const Products = artifacts.require("Products");
const Reviews = artifacts.require("Reviews");
const Categories = artifacts.require("Categories");
const Orders = artifacts.require("Orders");

module.exports = function (deployer) {
  deployer.deploy(Products);
  deployer.deploy(Reviews);
  deployer.deploy(Categories);
  deployer.deploy(Orders);
};
