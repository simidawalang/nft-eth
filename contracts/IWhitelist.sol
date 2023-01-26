// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.10;

interface IWhitelist {
    function whitelistedAddresses(address) external view returns (bool);
}