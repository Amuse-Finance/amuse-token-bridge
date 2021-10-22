// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./oracle/OracleBase.sol";

contract AmuseBridge is OracleBase {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public currentIdCount;

    function _fulfill(address _user, uint256 _amount, uint256 _nonce) internal virtual override {
        AmuseToken.transfer(_user, _amount);
        totalValueLocked -= _amount;
        AmuseToken.transfer(_user, _amount);
        emit Withdraw(_user, _amount, _nonce, block.timestamp);
    }


    function deposit(uint256 _amount) external whenNotPaused {
        AmuseToken.transferFrom(_msgSender(), address(this), _amount);
        uint256 _currentIdCount = currentIdCount.current();
        currentIdCount.increment();

        totalValueLocked += _amount;
        uint256 _nonce = nonces[_msgSender()];

        trades[_currentIdCount] = Trade(
            _msgSender(),
            _amount,
            _nonce,
            DEADLINE,
            block.timestamp
        );
        nonces[_msgSender()] += 1;

        emit Deposit(_msgSender(), _amount, _nonce, DEADLINE + block.timestamp, block.timestamp);
    }


}