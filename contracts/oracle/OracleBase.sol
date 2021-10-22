// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import { AmuseBaseFactory } from "../AmuseBaseFactory.sol";

abstract contract OracleBase is AmuseBaseFactory {
    mapping(address => uint256) public nonces;

    modifier onlyOracleCaller() {
        require(hasRole(ORACLE_CALLER, _msgSender()));
        _;
    }

    function _fulfill(address _user, uint256 _amount, uint256 _nonce) internal virtual;

    function execute(bytes memory _data) external onlyOracleCaller {
        (
            address user, 
            uint256 amount,
            uint256 nonce, 
            uint256 deadline
        ) = abi.decode(_data, (address, uint256, uint256, uint256));

        require(deadline <= block.timestamp, "AmuseBridge: Deadline has already expired");
        require(nonces[user] == nonce, "AmuseBridge: Invalid nonce received");
        require(user != address(0), "AmuseBridge: user can not be ZERO_ADDRESS");
        require(amount > 0, "AmuseBridge: Amount must be greater than zero");

        nonces[user] += 1;
        _fulfill(user, amount, nonce);
    }
}