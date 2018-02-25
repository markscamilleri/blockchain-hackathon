pragma solidity ^0.4.20;

import "identity_module.sol";


contract IdentityFactory {
  
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

    // Use address or type?
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
