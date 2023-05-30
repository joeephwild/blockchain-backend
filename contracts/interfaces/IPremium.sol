//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPremium {
    function _whitelistedAddresses(address) external view returns (bool);
}