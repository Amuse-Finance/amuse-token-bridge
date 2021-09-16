const hre = require("hardhat");
const { upgrades } = require("hardhat");

async function main() {
	const AmuseBridge = await ethers.getContractFactory("AmuseBridge");
	const amuseBridge = await upgrades.deployProxy(AmuseBridge, []);
	await amuseBridge.deployed();
	console.log("Amuse Bridge deployed to:", amuseBridge.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
