pragma solidity ^0.4.20;


contract Identity {
    address private owner;
    string private legacyId;
    string private name;
    string private surname;
    string private locality;
    string private nationality;
    uint private dateOfBirth;

    enum Gender {MALE, FEMALE, X}
    Gender private gender;


    bool private isRevoked = false;

    bytes32 private hashedRevocationCertificate;

    function getDetails() external view returns
        (address, string, string, string, string, string, Gender, uint, bool) {

        return(owner, legacyId, name, surname, locality, nationality, gender, dateOfBirth, isRevoked);
    }

    modifier onlyBy(address who) {
        require(msg.sender == who);
        _;
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
