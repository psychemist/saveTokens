// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract W3CXI is ERC20 {
    address private _owner;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 supply_,
        address account_
    ) ERC20(name_, symbol_) {
        _owner = msg.sender;
        _mint(account_, supply_);
    }

    modifier isOwner() {
        require(msg.sender == _owner);
        _;
    }

    function getTokens(uint256 _amount) external isOwner {
        require(msg.sender != address(0), "Sender cannot be Address Zero!");
        require(_amount > 0, "Cannot transfer 0 tokens!");
        require(IERC20(address(this)).balanceOf(address(this)) >= _amount);

        IERC20(address(this)).transfer(msg.sender, _amount);
    }

    function mintMoreTokens(uint256 _amount) external {
        require(msg.sender == _owner, "Only owner can mint more tokens!");
        _mint(_owner, _amount);
    }
}
