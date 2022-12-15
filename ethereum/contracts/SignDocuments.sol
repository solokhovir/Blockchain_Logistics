//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract TestSign {
    struct Documents {
        string docCID;
        address senderAddress;
        address signerAddress;
        bool signed;
    }

    mapping(string => Documents) public getDocumentInfo;

    function addDoc(string memory _docCID, address _signerAddress) public {
        // address _senderAddress = msg.sender;
        getDocumentInfo[_docCID].docCID = _docCID;
        getDocumentInfo[_docCID].signerAddress = _signerAddress;
        getDocumentInfo[_docCID].senderAddress = msg.sender;
    }

    function signDocument(string memory _docCID) public {
        if (msg.sender == getDocumentInfo[_docCID].signerAddress) {
            getDocumentInfo[_docCID].signed = true;
        }
        else {
            revert("You can not sign this document");
        }
    }
}