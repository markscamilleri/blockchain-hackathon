pragma solidity ^0.4.19;

//import "browser/identity_module.sol";
contract Qualifications{
    struct OwnerQualification{ //Attributes related to qualification
        //address qOwnerAddress; //Address of Owner
        string qType; //O'Level
        string qSubject; //Maths
        uint24 qDateAttained; //E.g. 20181231 
        string qInstitute; //MATSEC
        string qGrade; //2
    }
    
    OwnerQualification[] ownerQualifications;
    
    function _addQual(string _type, string _subject, 
    uint24 _dateAttained, string _institute, string _grade) public {

        //ownerQualifications[_qualCount].qType=_type;
        //ownerQualifications[_qualCount].qSubject=_subject;
        //ownerQualifications[_qualCount].qDateAttained=_dateAttained;
        //ownerQualifications[_qualCount].qInstitute=_institute;
        //ownerQualifications[_qualCount].qGrade=_grade;
        
        //uint8 newQualCount = _qualCount++;
        
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
    function _addQualification(uint8 _qualCount, string _type,
    string _subject, uint24 _dateAttained, string _institute, string _grade) 
    public{
        Qualifications qlf = new Qualifications();
        qlf._addQual(_type, _subject, _dateAttained, _institute, _grade);
    } 
}

contract DeployQualFactory{
    function _deployAddQualification(uint8 _qualCount, string _type,
    string _subject, uint24 _dateAttained, string _institute, string _grade) external{
        QualFactory qlfFac = new QualFactory();
        qlfFac._addQualification(_qualCount, _type, _subject,
        _dateAttained, _institute, _grade);
    }
}
