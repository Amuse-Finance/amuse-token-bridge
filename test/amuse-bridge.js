const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getDomainSeparator } = require("./utils/utilities");

const toWei = (_amount) => ethers.utils.parseEther(_amount.toString());
const fromWei = (_amount) => ethers.utils.formatEther(_amount.toString());

describe("Amuse Bridge", () => {
	let deployer, user1, user2, user3;

	beforeEach(async () => {
		const AmuseToken = await ethers.getContractFactory("AmuseToken");
		const AmuseBridge = await ethers.getContractFactory("AmuseBridge");

		this.amuseToken = await upgrades.deployProxy(AmuseToken, []);
		this.amuseBridge = await upgrades.deployProxy(AmuseBridge, [
			this.amuseToken.address,
		]);

		[deployer, user1, user2, user3] = await ethers.getSigners();

		await this.amuseToken
			.connect(deployer)
			.transfer(user1.address, toWei(10000));

		await this.amuseToken
			.connect(deployer)
			.transfer(user2.address, toWei(10000));

		await this.amuseToken
			.connect(deployer)
			.transfer(user3.address, toWei(10000));
	});

	describe("deployment", () => {
		it("should deploy contract properly", async () => {
			expect(this.amuseBridge.address).not.null;
			expect(this.amuseBridge.address).not.undefined;
		});

		it("should set Amuse Token address properly", async () => {
			expect(await this.amuseBridge.AmuseToken()).to.equal(
				this.amuseToken.address
			);
		});

		it("should set totalValueLocked to zero", async () => {
			expect((await this.amuseBridge.totalValueLocked()).toNumber()).to.equal(
				0
			);
		});
	});

	describe("deposit()", () => {
		const _amount = toWei(10);
		let _receipt;
		beforeEach(async () => {
			await this.amuseToken
				.connect(user1)
				.approve(this.amuseBridge.address, toWei(_amount));

			_receipt = await this.amuseBridge.connect(user1).deposit(_amount);
		});

		it("should deposit AMD token properly", async () => {
			const { user, amount, nonce, deadline } = await this.amuseBridge.trades(
				"0"
			);
			expect(user).to.equal(user1.address);
			expect(fromWei(amount)).to.equal(fromWei(_amount));
			expect(nonce.toNumber()).to.equal(0);
			expect(deadline.toNumber()).to.above(0);
		});

		it("should emit Deposit event", async () => {
			const { user, amount, nonce, deadline } = await this.amuseBridge.trades(
				"0"
			);

			expect(_receipt)
				.to.emit(this.amuseBridge, "Deposit")
				.withArgs(user, amount, nonce, deadline);
		});
	});
});
