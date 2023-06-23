// SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 < 0.9.0;

contract Insurance { // we are creating a smart contract to automatically claim flight insurance when the client's flight is delayed
// assume that the contract is only valid for one flight
    struct Content {
        string cName;
        string cNric;
        string fCode;
        uint256 contractValue;
        uint256 aTakeOff;
        uint256 fTakeOff;
        bool isClaimed; // have the insurance monies been paid out
        bool isExpired;
    }

    address contractOwner;

    mapping(address => Content) private contents;

    modifier onlyOwner {
        require(msg.sender == contractOwner);
        _;
    }

    constructor() payable {
        contractOwner = msg.sender;
    }

    function onboarding(string memory c_name, string memory c_nric, string memory flight_code, uint256 takeoff_date, uint256 amount) public returns (address) {
        address contractId = address(uint160(uint256(keccak256(abi.encodePacked(c_nric, flight_code, takeoff_date)))));
        contents[contractId].cName = c_name;
        contents[contractId].cNric = c_nric;
        contents[contractId].contractValue = amount;
        contents[contractId].fCode = flight_code;
        contents[contractId].fTakeOff = takeoff_date;
        contents[contractId].isClaimed = false;
        contents[contractId].isExpired = false;
        return contractId;
    }

    function boardFlight(address contract_id) onlyOwner public payable returns (string memory) {
        if (contents[contract_id].fTakeOff < block.timestamp) {
            payable(contractOwner).transfer(contents[contract_id].contractValue);
            contents[contract_id].isClaimed = true;
            contents[contract_id].isExpired = true;
            return "Flight delayed, payout claimed";
        } else {
            contents[contract_id].isExpired = true;
            return "Flight not delayed, payout not claimed";
        }
    }

    function checkInsuranceStatus(address contract_id) onlyOwner public view returns (string memory) {
        if (contents[contract_id].isClaimed && contents[contract_id].isExpired) {
            return "You have received a payout from this flight insurance";
        } else if (!contents[contract_id].isClaimed && !contents[contract_id].isExpired) {
            return "Your flight was not delayed, you have not received an insurance payout";
        } else {
            return "Your flight was delayed, but you have not received an insurance payout";
        }
    }

    fallback() external payable {
        payable(contractOwner).transfer(msg.value);
    }

    receive() external payable {
        payable(contractOwner).transfer(msg.value);
    }
}
