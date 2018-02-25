pragma solidity ^0.4.20;

import "identity.sol";


contract IdentityModule {
    Identity public owner;
    bool public isInitialized = false;

    function IdentityModule(Identity _owner) internal {
        owner = _owner;
        isInitialized = true;
        require(owner.registerModule(owner, this));
    }

    function getModuleName() internal view returns (string);
}
