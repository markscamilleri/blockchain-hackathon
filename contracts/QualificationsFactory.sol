pragma solidity ^0.4.19;

import "./Factory.sol";
import "./Identity.sol";
import "./Qualifications.sol";


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
