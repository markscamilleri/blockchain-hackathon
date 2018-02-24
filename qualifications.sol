pragma solidity ^0.4.18;
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
    
    function _addQualFunc(uint256 _qualUniqueID, address _Address, string _Name, uint24 _DateAttained, string _Institute, string _Grade){
        
        qualStructs[_qualUniqueID].qAddress=_Address;
        qualStructs[_qualUniqueID].qName=_Name;
        qualStructs[_qualUniqueID].qDateAttained=_DateAttained;
        qualStructs[_qualUniqueID].qInstitute=_Institute;
        qualStructs[_qualUniqueID].qGrade=_Grade;
        
        globalQuals.push(_qualUniqueID);
    }
    
    function _generateQualID(string _LegacyID, uint8 _QualCount) returns (uint256){
        string memory stringQualCount = bytes32ToString(bytes32(_QualCount));
        //string a = "ads";
        //string b = "hfg";
        string memory preHash = strConcat(_LegacyID, stringQualCount);
        uint256 qualUniqueID = uint256(keccak256(preHash));
        
        return qualUniqueID;
    }
    
    function _
    
    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);                
        bytes memory _bb = bytes(_b);
        string memory fullString = new string(_ba.length + _bb.length);
        bytes memory bytesFullString = bytes(fullString);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bytesFullString[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bytesFullString[k++] = _bb[i];
        return string(bytesFullString);
    }  
    
     function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
 
}