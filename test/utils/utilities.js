const { ethers } = require("hardhat");
const { defaultAbiCoder, keccak256, toUtf8Bytes } = ethers.utils;

const getDomainSeparator = (_name, _address) => {
	return keccak256(
		defaultAbiCoder.encode(
			["bytes32", "bytes32", "bytes32", "uint256", "address"],
			[
				keccak256(
					toUtf8Bytes(
						"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
					)
				),
				keccak256(toUtf8Bytes(_name)),
				keccak256(toUtf8Bytes("4")),
				4,
				_address,
			]
		)
	);
};

module.exports = {
	getDomainSeparator,
};
