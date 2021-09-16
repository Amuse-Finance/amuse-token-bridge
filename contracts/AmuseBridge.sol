// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "./oracle/OracleBase.sol";

contract AmuseBridge is OracleBase {
    IERC20Upgradeable public AmuseToken;
    function initialize(IERC20Upgradeable _amuseToken) public virtual initializer {
        AmuseToken = _amuseToken;
        super.initialize();
    }

    function _fulfill(address user, uint256 amount, uint8 direction, uint256 nonce, uint256 deadline) internal virtual override {
        if(direction == 0) {
            AmuseToken.transferFrom(user, address(this), amount);
            totalValueLocked += amount;
            emit Deposit(user, amount, nonce, deadline, block.timestamp);
        } else {
            AmuseToken.transfer(user, amount);
            totalValueLocked -= amount;
            emit Withdraw(user, amount, nonce, deadline, block.timestamp);
        }
    }
}