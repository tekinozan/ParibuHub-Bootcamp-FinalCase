// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Paribuhub {
    struct Account {
        string name;
        string surname;
        uint256 balance;
    }

    Account[] admins;
    uint256 public index;

    function addAdmin(Account memory admin) public {
        admins[index++] = admin;
    }

    function getAllAdmins() public view returns (Account[] memory) {
        Account[] memory _admins = new Account[](admins.length);
        for (uint256 i = 0; i < index; i++) {
            _admins[i] = admins[i];
        }

        return _admins;
    }
}
