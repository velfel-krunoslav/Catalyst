module.exports = {
  networks: {
    development: {
<<<<<<< HEAD
      host: "192.168.1.8",
=======
      host: "192.168.1.2",
>>>>>>> stefan-a
      port: 7545,
      network_id: "*", // Match any network id
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
