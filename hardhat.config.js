require("@nomiclabs/hardhat-waffle");
require("@openzeppelin/hardhat-upgrades");
require("hardhat-gas-reporter");
require("dotenv/config");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

module.exports = {
	networks: {
		hardhat: {},
		rinkeby: {
			url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.alchemyApiKey}`,
			accounts: [process.env.PRIVATE_KEY],
			chainId: 4,
		},
	},
	solidity: {
		compilers: [{ version: "0.8.7" }],
	},
	gasReporter: {
		currency: "USD",
		enabled: true,
		coinmarketcap: process.env.coinmarketcap,
	},
};
