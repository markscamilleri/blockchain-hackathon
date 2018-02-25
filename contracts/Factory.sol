pragma solidity ^0.4.19;


contract Factory {
    address public owner;

    mapping(address => bool) private authorizedAuthorities;

    modifier isAuthorized(address auth) {
        require(authorizedAuthorities[auth]);
        _;
    }

    modifier isNotOwner(address addr) {
        require(addr != owner);
        _;
    }

    function Factory() internal {
        authorizedAuthorities[msg.sender] = true;
        owner = msg.sender;
    }

    function createObject() external isAuthorized(msg.sender) returns (address);

    function giveAuthorizationTo(address newAuth) public isAuthorized(msg.sender) {
        authorizedAuthorities[newAuth] = true;
    }

    function removeAuthorizationFrom(address newAuth) public isAuthorized(msg.sender) isNotOwner(newAuth) {
        authorizedAuthorities[newAuth] = false;
    }

    function changeOwner(address newOwner) public isAuthorized(newOwner) isNotOwner(newOwner) {
        owner = newOwner;
    }
}
