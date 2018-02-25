pragma solidity ^0.4.19;

import "identity_module.sol";


contract IdentityFactory is Factory {
    mapping(string => Idenitty) private identitiesIssued;

    struct ID {
        address public owner;
        string public legacyId;
        string public name;
        string public surname;
        string public locality;
        string public nationality;
        uint public dateOfBirth;

        Identity.Gender public gender;
    }

    ID private toAdd;

    modifier isNotEmpty(ID toCheck) {
        require(toCheck.owner != 0x0 &&
                !strEmpty(toCheck.legacyId) &&
                !strEmpty(toCheck.name) &&
                !strEmpty(toCheck.surname) &&
                !strEmpty(toCheck.locality) &&
                !strEmpty(toCheck.nationality) &&
                toCheck.dateOfBirth > 0);
        _;
    }

    function setID(address owner, string legacyId, string name, string surname,
    string locality, string nationality, string dateOfBirth) external isAuthorized(msg.sender) returns () {
        toAdd.owner = owner;
        toAdd.legacyId = legacyId;
        toAdd.name = name;
        toAdd.surname = surname;
        toAdd.locality = locality;
        toAdd.nationality = nationality;
        toAdd.dateOfBirth = dateOfBirth;
    }

    function createObject() external isNotEmpty(toAdd) returns (address) {
        identitiesIssued[toAdd.legacyId] = new Identity(toAdd.owner,
                                                        msg.sender,
                                                        toAdd.legacyId,
                                                        toAdd.name,
                                                        toAdd.surname,
                                                        toAdd.locality,
                                                        toAdd.nationality,
                                                        toAdd.gender,
                                                        toAdd.dateOfBirth);
    }

    function lookupIdentity(string legacyId) external view returns (Identity) {
        return identitiesIssued[legacyId];
    }

    function strEmpty(string str) internal returns (bool) {
        bytes memory bytesStr = bytes(str);

        return bytesStr.length == 0;
    }
}


contract Identity {
    address public owner;
    address public issuingAuthority;
    string public legacyId;
    string public name;
    string public surname;
    string public locality;
    string public nationality;
    uint public dateOfBirth;

    enum Gender {MALE, FEMALE, X}
    Gender public gender;

    bool public isRevoked = false;

    bytes32 private hashedRevocationCertificate;

    mapping(address => IdentityModule) private modulesRegistered;
    uint public modulesRegisteredSize = 0;

    modifier onlyBy(address who) {
        require(msg.sender == who);
        _;
    }

    modifier hasModulesRegistered() {
        require(modulesRegisteredSize > 0);
        _;
    }

    modifier moduleNotRegistered(address factoryAddress) {
        require(modulesRegistered[factoryAddress].isInitialized() == false);
        _;
    }

    function Identity external(address _owner, address _issuingAuthority, string _legacyId,
    string _name, string _surname, string _locality, string _nationality, uint _dateOfBirth, Gender _gender) {
        owner = _owner;
        issuingAuthority = _issuingAuthority;
        legacyId = _legacyId;
        name = _name;

    }

    function registerModule(address factoryAddress, IdentityModule module) external
    moduleNotRegistered(factoryAddress) returns (bool) {
        modulesRegistered[factoryAddress] = module;
        return ++modulesRegisteredSize > 0 && modulesRegistered[factoryAddress].isInitialized();
    }

    function deregisterModule(address factoryAddress) external hasModulesRegistered() returns (bool) {
        delete modulesRegistered[factoryAddress];
        return --modulesRegisteredSize >= 0 && !modulesRegistered[factoryAddress].isInitialized();
    }

    function getDetails() external view returns
        (address, address, string, string, string, string, string, Gender, uint, bool) {

        return(owner, issuingAuthority, legacyId, name, surname, locality, nationality, gender, dateOfBirth, isRevoked);
    }

    function generateRevocationCertificate() public onlyBy(owner) returns (bytes32) {
        bytes32 revocationCertificte = keccak256(this, owner, block.number, block.gaslimit);
        hashedRevocationCertificate = keccak256(revocationCertificte);
        return revocationCertificte;
    }

    function revoke(bytes32 cert) public {
        require(keccak256(cert) == hashedRevocationCertificate);
        isRevoked = true;
    }
}
