const { expect } = require("chai");

describe("AmuseBridge", function () {
	// it("works", async () => {
	// 	const AmuseBridge = await ethers.getContractFactory("AmuseBridge");
	// 	const BoxV2 = await ethers.getContractFactory("BoxV2");
	// 	const instance = await upgrades.deployProxy(Box, [42]);
	// 	const upgraded = await upgrades.upgradeProxy(instance.address, BoxV2);
	// 	const value = await upgraded.value();
	// 	expect(value.toString()).to.equal("42");
	// });

	beforeEach(async () => {
		const AmuseBridge = await ethers.getContractFactory("AmuseBridge");
		this.amuseBridge = await upgrades.deployProxy(AmuseBridge, []);
	});
});
