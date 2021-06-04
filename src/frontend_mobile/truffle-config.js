module.exports = {
  networks: {
    development: {
      host: "192.168.0.101",
      port: 7545,
      network_id: "*", // Match any network id
      from: "0x459ca368505e9e0600f9f926ef9d3d2cb0c9e4bb"
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
