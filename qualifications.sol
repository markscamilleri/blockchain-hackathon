pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;
contract Qualifications{
    struct Qualification{ //Attributes related to qualification
        address qAddress;
        string qName;
        uint24 qDateAttained; //E.g. 01012018  
        string qInstitute;
        string qGrade;
    }
    
/*
Process: The indexes of an array with the attributes of a qualification, are recorded into another
array, not to have duplicates (thus overriding) a Keccak is done with the hash of a string concetation
of the LegacyID with the Qualification Count of the Person
*/
    mapping(uint => Qualification) qualStructs;
    uint256[] globalQuals;
    
    function _addQual(string _legacyID, uint8 _qualCount, address _address, string _name, uint24 _dateAttained, string _institute, string _grade) returns(uint8, uint256){
        
        qualUniqueID = _generateQualID(string _legacyID, uint8 _qualCount);
        
        qualStructs[qualUniqueID].qAddress=_address;
        qualStructs[qualUniqueID].qName=_name;
        qualStructs[qualUniqueID].qDateAttained=_dateAttained;
        qualStructs[qualUniqueID].qInstitute=_institute;
        qualStructs[qualUniqueID].qGrade=_grade;
        
        uint8 newQualCount = _qualCount++;
        globalQuals.push(qualUniqueID);
        return newQualCount;
    }
    
    function _generateQualID(string _legacyID, uint8 _qualCount) returns (uint256){
        uint256 qualUniqueID = uint256(keccak256(_legacyID,_qualCount));
        return qualUniqueID;
    }
    
    function _getQualIDsByPerson(string _legacyID, uint8 _qualCount) returns (uint256[]){
        uint256[] qualIDs;
        uint256 elemQualID;
        for(uint i=1; i<=_qualCount;i++){
            elemQualID= _generateQualID( _legacyID, _qualCount);
            qualIDs.push(elemQualID); 
        }
        return(qualIDs);
    }
    
    function _getQualInfo(uint256 _qualIndex, Qualification _qualArray)returns(
        address, string, uint24, string, string){
            
        return (qualStructs[_qualIndex].qAddress, qualStructs[_qualIndex].qName, 
        qualStructs[_qualIndex].qDateAttained, qualStructs[_qualIndex].qInstitute, 
        qualStructs[_qualIndex].qGrade);
    }
}
