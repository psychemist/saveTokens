// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SaveEther is ReentrancyGuard {
    address public owner;
    mapping(address user => uint256) balances;

    event DepositSuccessful(address indexed sender, uint amount);
    event CharityDepositSuccessful(
        address indexed sender,
        address indexed receiver,
        uint amount
    );
    event WithdrawSuccessful(address indexed receiver, uint amount);
    event TransferSuccessful(
        address indexed sender,
        address indexed receiver,
        uint amount
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Transaction sender not owner!");
        _;
    }

    function deposit() external payable nonReentrant {
        require(msg.sender != address(0), "Zero address detected!");
        require(msg.value > 0, "Cannot deposit zero!");

        balances[msg.sender] += msg.value;

        emit DepositSuccessful(msg.sender, msg.value);
    }

    function depositForOther(address _to) external payable nonReentrant {
        require(msg.sender != address(0), "Zero address detected!");
        require(msg.value > 0, "Cannot deposit zero!");

        balances[_to] += msg.value;

        emit CharityDepositSuccessful(msg.sender, _to, msg.value);
    }

    function withdraw(uint _amount) external nonReentrant {
        require(msg.sender != address(0), "Zero address detected!");
        require(_amount > 0, "Cannot withdraw zero amount!");
        require(balances[msg.sender] >= _amount, "Insufficient funds!");

        balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Ether transfer failed!");

        emit WithdrawSuccessful(msg.sender, _amount);
    }

    function transferEtherInternal(
        address _to,
        uint256 _amount
    ) external nonReentrant {
        require(msg.sender != address(0), "Zero address detected!");
        require(_amount > 0, "Cannot withdraw zero amount!");
        require(balances[msg.sender] >= _amount, "Insufficient funds!");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit TransferSuccessful(msg.sender, _to, _amount);
    }

    function transferEtherExternal(
        address _to,
        uint256 _amount
    ) external payable nonReentrant {
        require(msg.sender != address(0), "Zero address detected!");
        require(_amount > 0, "Cannot withdraw zero amount!");
        require(balances[msg.sender] >= _amount, "Insufficient funds!");

        balances[msg.sender] -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Ether transfer failed!");

        emit TransferSuccessful(msg.sender, _to, msg.value);
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getAccountBalance(
        address _account
    ) external view onlyOwner returns (uint256) {
        return balances[_account];
    }

    function getContractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}
