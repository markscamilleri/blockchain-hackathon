pragma solidity ^0.4.20;

import "identity.sol";


contract IdentityModule {
    Identity private owner;

    function IdentityModule(Identity ownerId) internal {
        owner = ownerId;
        require(ownerId.registerModule(this));
    }

    function getOwnerIdentity() external view returns(Identity) {
        return owner;
    }

    function getModuleName() internal view returns (string);
}
