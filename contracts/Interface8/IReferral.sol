// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRefferal {
    function sum(uint[] memory data) external pure returns (uint);

    function hasReferrer(address addr) external view returns(bool);

    function getTime() external view returns(uint256);

    function getRefereeBonusRate(uint256 amount) external view returns(uint256);

    function isCircularReference(address referrer, address referee) external view returns(bool);

    function addReferrer(address payable referrer) external returns(bool);

    function payReferral(uint256 value) external returns(uint256);

    function updateActiveTimestamp(address user) external;
}