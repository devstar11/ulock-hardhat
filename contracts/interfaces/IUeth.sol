// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.6.6;
// Copyright (C) udev 2020

import "../ERC20/IERC20.sol";

interface IUeth is IERC20 {
    function deposit() external payable;
    function ulockerMint(uint wad, address dst) external;
    function withdraw(uint wad) external;
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);
    event UlockerMint(uint wad, address dst);
}