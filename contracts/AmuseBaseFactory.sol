// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";


contract AmuseBaseFactory is Initializable, AccessControlUpgradeable, PausableUpgradeable {
    IERC20Upgradeable public AmuseToken;
    bytes32 public constant ORACLE_CALLER = keccak256("ORACLE_CALLER");
    uint256 public totalValueLocked;
    uint256 public DEADLINE;

    mapping(uint256 => Trade) public trades;

    struct Trade {
        address user;
        uint256 amount;
        uint256 nonce;
        uint256 deadline;
        uint256 timestamp;
    }


    event Deposit(address indexed user, uint256 amount, uint256 nonce, uint256 deadline, uint256 timestamp);
    event Withdraw(address indexed user, uint256 amount, uint256 nonce, uint256 timestamp);

    function initialize(IERC20Upgradeable _amuseToken) public virtual initializer {
        AmuseToken = _amuseToken;
        totalValueLocked = 0;
        DEADLINE = 30 minutes;

        _setupRole(ORACLE_CALLER, _msgSender());
        super.__Pausable_init();
    }
    
}