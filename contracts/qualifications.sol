pragma solidity ^0.4.19;

import "identity_module.sol";
import "identity.sol";
import "factory.sol";


contract Qualifications is IdentityModule {
    struct OwnerQualification {
        //Attributes related to qualification
        string qType; //E.g. O Level, A Level, Certificate, Bachelors, Masters...
        string qSubject; //E.g. in what? Maths, Computing Science etc...
        uint qDateAttained; //E.g. Epoch timestamp
        string qInstitute; //Issuer of qualification
        uint qLevel; //National Qualifications Framework Level
    }

    address private issuerAddress;

    OwnerQualification[] private ownerQualifications;

    modifier isIssuer(address toCheck) {
        require(toCheck == issuerAddress);
        _;
    }

    function Qualifications(address issuer, Identity _owner) public IdentityModule(_owner) {
        issuerAddress = issuer;
    }

    function _addQual(string _type, string _subject, uint _dateAttained,
    string _institute, uint _level) external isIssuer(msg.sender) {
        ownerQualifications.push(
            OwnerQualification(_type, _subject, _dateAttained, _institute, _level));
    }

    function _getQualInfo(uint _qualIndex) external view returns(string, string, uint, string, uint) {
        return (ownerQualifications[_qualIndex].qType, ownerQualifications[_qualIndex].qSubject,
        ownerQualifications[_qualIndex].qDateAttained, ownerQualifications[_qualIndex].qInstitute,
        ownerQualifications[_qualIndex].qLevel);
    }

    function hasQualifications() external view returns (bool) {
        return ownerQualifications.length != 0;
    }

    function getModuleName() internal view returns (string) {
        return "Qualifications";
    }

}


contract QualificationsFactory is Factory {

    struct Qual {
        bool isInUse;
        Identity owner;
        string qualificationType;
        string subject;
        uint dateAttained;
        string institute;
        uint level;
    }

    Qual private toAdd;

    modifier isNotEmpty(Qual toCheck) {
        require(toCheck.isInUse);
        _;
    }

    function createObject() external isAuthorized(msg.sender) isNotEmpty(toAdd) returns (address) {
        Qualifications qualifications = Qualifications(toAdd.owner.lookupModule(this));
        if (!qualifications.hasQualifications()) {
            qualifications = new Qualifications(this, toAdd.owner);
        }

        qualifications._addQual(toAdd.qualificationType, toAdd.subject,
        toAdd.dateAttained, toAdd.institute, toAdd.level);

        toAdd.isInUse = false;

        return qualifications;
    }

    function _setQualificationToAdd(Identity _owner, string _type, string _subject,
    uint _dateAttained, string _institute, uint _level) public isAuthorized(msg.sender) {
        toAdd = Qual(true, _owner, _type, _subject, _dateAttained, _institute, _level);
    }
}
