module.exports = {
  networks: {
    development: {
      host: "192.168.1.8",
      port: 7545,
      network_id: "*", // Match any network id
      from: "0x459CA368505e9E0600F9f926EF9d3d2cB0c9E4bb"
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
