pragma solidity ^0.4.19;

import "./Identity.sol";


contract IdentityFactory is Factory {
    mapping(string => Identity) private identitiesIssued;

    struct ID {
        bool isInUse;
        address owner;
        string legacyId;
        string name;
        string surname;
        string locality;
        string nationality;
        uint dateOfBirth;

        Identity.Gender gender;
    }

    ID private toAdd;
    string private lastLegacyId;

    modifier isNotEmpty(ID toCheck) {
        require(toCheck.isInUse);
        _;
    }

    function IdentityFactory() public Factory() {}

    function setID(address owner, string legacyId, string name, string surname,
    string locality, string nationality, uint dateOfBirth, Identity.Gender gender) external isAuthorized(msg.sender) {
        toAdd.isInUse = true;
        toAdd.owner = owner;
        toAdd.legacyId = legacyId;
        toAdd.name = name;
        toAdd.surname = surname;
        toAdd.locality = locality;
        toAdd.nationality = nationality;
        toAdd.dateOfBirth = dateOfBirth;
        toAdd.gender = gender;
    }

    function createObject() external isNotEmpty(toAdd) returns (address) {
        identitiesIssued[toAdd.legacyId] = new Identity(toAdd.owner,
                                                        msg.sender,
                                                        toAdd.legacyId,
                                                        toAdd.name,
                                                        toAdd.surname,
                                                        toAdd.locality,
                                                        toAdd.nationality,
                                                        toAdd.dateOfBirth,
                                                        toAdd.gender);
        toAdd.isInUse = false;
        lastLegacyId = toAdd.legacyId;
        return identitiesIssued[toAdd.legacyId];
    }

    function getLastObjectCreated() external view returns (Identity) {
        return lookupIdentity(lastLegacyId);
    }

    function lookupIdentity(string legacyId) external view returns (Identity) {
        return identitiesIssued[legacyId];
    }

    function strEmpty(string str) internal pure returns (bool) {
        bytes memory bytesStr = bytes(str);

        return bytesStr.length == 0;
    }
}
