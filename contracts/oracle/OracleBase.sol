// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

abstract contract OracleBase is Initializable, AccessControlUpgradeable {
    bytes32 public constant ORACLE_CALLER = keccak256("ORACLE_CALLER");
    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("_validateSignature(address user,uint value,uint8 direction,uint256 nonce,uint256 deadline)")
    bytes32 public constant PERMIT_TYPEHASH = keccak256("_validateSignature(address user,uint value,uint8 direction,uint256 nonce,uint256 deadline)");
    uint256 public totalValueLocked;

    mapping(address => uint256) public nonces;

    modifier onlyOracleCaller() {
        require(hasRole(ORACLE_CALLER, _msgSender()));
        _;
    }

    event Deposit(address indexed user, uint256 amount, uint256 nonce, uint256 deadline, uint256 timestamp);
    event Withdraw(address indexed user, uint256 amount, uint256 nonce, uint256 deadline, uint256 timestamp);

    function initialize() public virtual {
        totalValueLocked = 0;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes("AmuseBridge")),
                keccak256(bytes('1')),
                block.chainid,
                address(this)
            )
        );

        _setupRole(ORACLE_CALLER, _msgSender());
    }

    function _fulfill(address user, uint256 amount, uint8 direction, uint256 nonce, uint256 deadline) internal virtual;

    function encodeArgs(
        address user, 
        uint256 amount, 
        uint8 direction, 
        uint256 nonce, 
        uint256 deadline, 
        uint8 v, 
        bytes32 r, 
        bytes32 s
    ) external pure returns(bytes memory) {
        return abi.encode(user, amount, direction, nonce, deadline, v, r, s);
    }

    function _validateSignature(
        address user, 
        uint256 value, 
        uint8 direction, 
        uint256 nonce, 
        uint256 deadline, 
        uint8 v, 
        bytes32 r, 
        bytes32 s
    ) internal view {
        bytes32 _digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, user, value, direction, nonce, deadline))
            )
        );
        address _recoveredAddress = ecrecover(_digest, v, r, s);
        require(_recoveredAddress == user, "AmuseBridge: INVALID_SIGNATURE");
    }

    function execute(bytes memory _data) external onlyOracleCaller {
        (
            address user, 
            uint256 amount,
            uint8 direction, 
            uint256 nonce, 
            uint256 deadline,
            uint8 v, 
            bytes32 r, 
            bytes32 s
        ) = abi.decode(_data, (address, uint256, uint8, uint256, uint256, uint8, bytes32, bytes32));

        require(deadline <= block.timestamp, "AmuseBridge: Deadline has already expired");
        require(nonces[user] == nonce, "AmuseBridge: Invalid nonce received");
        require(user != address(0), "AmuseBridge: user can not be ZERO_ADDRESS");
        require(amount > 0, "AmuseBridge: Amount must be greater than zero");

        _validateSignature(user, amount, direction, nonce, deadline, v, r, s);
        nonces[user] += 1;
        _fulfill(user, amount, direction, nonce, deadline);
    }
}