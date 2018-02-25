pragma solidity ^0.4.19;

import "./IdentityModule.sol";


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

    function Identity(address _owner, address _issuingAuthority, string _legacyId,
    string _name, string _surname, string _locality, string _nationality, uint _dateOfBirth, Gender _gender) public {
        owner = _owner;
        issuingAuthority = _issuingAuthority;
        legacyId = _legacyId;
        name = _name;
        surname = _surname;
        locality = _locality;
        nationality = _nationality;
        dateOfBirth = _dateOfBirth;
        gender = _gender;
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

    function lookupModule(address factoryAddress) external hasModulesRegistered() view returns (IdentityModule) {
        return modulesRegistered[factoryAddress];
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
