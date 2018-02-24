pragma solidity 0.4.21;


contract Identity {
    address private owner;
    string private legacyId;
    string private name;
    string private surname;
    string private addressLine1;
    string private addressLine2;
    string private locality;
    string private nationality;
    uint private dateOfBirth;

    function getDetails() external view returns
        (address, string, string, string, string, string, string, string, uint) {

        return(owner, legacyId, name, surname, addressLine1, addressLine2, locality, nationality, dateOfBirth);
    }
}
