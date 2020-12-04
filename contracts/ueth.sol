// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.6.6;
// Copyright (C) 2015, 2016, 2017 Dapphub / adapted by udev 2020

import "./interfaces/IUeth.sol";

contract UETH is IUeth {
    string public name;
    string public symbol;
    uint8  public decimals;
    address ulocker;
    uint public override totalSupply;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public override balanceOf;
    mapping (address => mapping (address => uint))  public override allowance;
    
    constructor() public {
        name = "ulock.eth Wrapped Ether";
        symbol = "UETH";
        decimals = 18;
        ulocker = msg.sender;
    }

    receive() external payable {
        deposit();
    }
    
    function deposit() public payable override {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function transferUlocker(address ulocker_) external {
        require(ulocker==msg.sender, "ulocker!=msg.sender");
        ulocker = ulocker_;
    }

    function ulockerMint(uint wad, address dst) external override {
        require(msg.sender == ulocker, "!ulocker");
        balanceOf[dst] += wad;
        totalSupply += wad;
        emit Transfer(address(0), dst, wad);
    }
    
    function withdraw(uint wad) external override {
        require(balanceOf[msg.sender] >= wad, "!balance");
        balanceOf[msg.sender] -= wad;
        totalSupply -= wad;
        (bool success, ) = msg.sender.call{value:wad}("");
        require(success, "!withdraw");
        emit Withdrawal(msg.sender, wad);
    }
    
    function _approve(address src, address guy, uint wad) internal {
        allowance[src][guy] = wad;
        emit Approval(src, guy, wad);
    }
    
    function approve(address guy, uint wad) external override returns (bool) {
        _approve(msg.sender, guy, wad); 
        return true;
    }
    
    function transfer(address dst, uint wad) external override returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    
    function transferFrom(address src, address dst, uint wad)
        public override
        returns (bool)
    {
        require(balanceOf[src] >= wad, "!balance");

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad, "!allowance");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}