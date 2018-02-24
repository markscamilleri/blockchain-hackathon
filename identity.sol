pragma solidity 0.4.2


contract Identity {
    address private onwer;
    string private legacyId;
    string private name;
    string private surname;
    string private addressLine1;
    string private addressLine2;
    string private locality;
    string private nationality;
    uint private dateOfBirth;

    function getDetails() public view {
        return(owner, legacyId, name, surname, addressLine1, addressLine2, locality, nationality, dateOfBirth)
    }
}
