pragma solidity ^0.4.20;

import "identity.sol";
import "identity_module_authority.sol";


contract IdentityModuleFactory {
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

    function IdentityModuleFactory() external {
        authorizedAuthorities[msg.sender] = true;
        owner = msg.sender;
    }

    function giveAuthorizationTo(address newAuth) public isAuthorized(msg.sender) {
        authorizedAuthorities[newAuth] = true;
    }

    function removeAuthorizationFrom(address newAuth) public isAuthorized(msg.sender) isNotOwner(newAuth) {
        authorizedAuthorities[newAuth] = false;
    }

    function getFactoryName() internal view returns (string); //force this to be abstract
}


contract IdentityModule {
    Identity public owner;
    bool public isInitialized = false;

    function IdentityModule(Identity _owner) internal {
        owner = _owner;
        isInitialized = true;
        require(owner.registerModule(owner, this));
    }

    function getModuleName() internal view returns (string); // force this to be abstract
}
