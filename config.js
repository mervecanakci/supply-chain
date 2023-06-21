module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // Ganache tarafından kullanılan port numarası
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "0.8.0", // Kullanılacak Solidity derleyici sürümü
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },
  gas: 9223372036854775808 // Maksimum gaz limiti
};
