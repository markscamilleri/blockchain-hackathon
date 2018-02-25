pragma solidity ^0.4.19;

import "./Identity.sol";
import "./Factory.sol";


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
