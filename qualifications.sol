pragma solidity ^0.4.19;

import "browser/identity_module.sol";
contract Qualifications is identity_module{
    struct OwnerQualification{ //Attributes related to qualificationr
        string qType; //O'Level
        string qSubject; //Maths
        uint24 qDateAttained; //E.g. 20181231 
        string qInstitute; //MATSEC
        string qGrade; //2
    }
    
    OwnerQualification[] ownerQualifications;
    
    function _addQual(string _type, string _subject, 
    uint24 _dateAttained, string _institute, string _grade) public {
        ownerQualifications.push(
            OwnerQualification(_type, _subject, _dateAttained, _institute, _grade));
    }
    
    function _getQualInfo(uint _qualIndex) external returns(string, string, uint24, string, string){
        return (ownerQualifications[_qualIndex].qType, ownerQualifications[_qualIndex].qSubject, 
        ownerQualifications[_qualIndex].qDateAttained, ownerQualifications[_qualIndex].qInstitute, 
        ownerQualifications[_qualIndex].qGrade);
    }
}

contract QualFactory{
    function _addQualification(string _type, string _subject,
    uint24 _dateAttained, string _institute, string _grade) 
    public{
        Qualifications qlfContract = new Qualifications();
        qlfContract._addQual(_type, _subject, _dateAttained, _institute, _grade);
    } 
}

contract DeployQualFactory{
    function _deployAddQualification(string _type, string _subject, uint24 _dateAttained,
    string _institute, string _grade) external{
        QualFactory qlfFac = new QualFactory();
        qlfFac._addQualification(_type, _subject, _dateAttained, _institute, _grade);
    }
}
