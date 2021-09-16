// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
contract AmuseToken is ERC20Upgradeable {
    function initialize() public virtual initializer {
        __ERC20_init("Amuse Finance", "AMD");
    _mint(msg.sender, 100_000_000 ether);
    }

    
 
}