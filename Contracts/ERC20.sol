// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    address public owner;

    constructor(uint256 initialSupply) ERC20("TEST", "TST") {
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Mint tokens function
    // Can only be called by owner
    function mint(uint256 _amount) public onlyOwner {
        _mint(msg.sender, _amount);
    }

    // Burn tokens function 
    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }
}
