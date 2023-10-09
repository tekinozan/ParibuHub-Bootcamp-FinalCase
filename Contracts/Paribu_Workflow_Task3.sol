// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Paribuhub {

    struct Account {
        string name;
        string surname;
        uint balance;
    }

    Account[] admins;
    uint private index;

    function addAdmin(Account memory admin) public {
       require(index<3, "Has no slot");
        admins[index++] = admin;
    }


    function getAllAdmins() public view returns(Account[] memory) {
    Account[] memory _admins = new Account[](index);
    for(uint i=0;i<index;i++){
        _admins[i] = admins[i];
    }

    return _admins;
}


}


