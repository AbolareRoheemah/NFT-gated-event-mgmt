// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Event {
    uint eventCount;
    struct EventStruct {
       string name;
       uint eventId;
       uint startAt;
       uint EndAt;
       bool isCompleted;
       address eventNFT;
       uint nftId;
       uint registeredAttendees; 
    }

    EventStruct[] allEvents;
    mapping (uint => EventStruct) events;

    event EventCreated(string name, uint startAt, uint endAt);

    function createEvent(address _nftAddress, string memory _name, uint _nftId, uint _startAt, uint _endAt) external {
        require(msg.sender != address(0), "invalid caller");
        require(_nftAddress != address(0), "invalid nft address");

        uint newCount = eventCount + 1;
        EventStruct storage newEvent = events[newCount];
        newEvent.name = _name;
        newEvent.eventId = newCount;
        newEvent.nftId = _nftId;
        newEvent.startAt = _startAt;
        newEvent.EndAt = _endAt;

        allEvents.push(newEvent);
        eventCount = newCount;

        emit EventCreated(_name, _startAt, _endAt);
    }

    function attendeeReg(uint _eventId) external {
        require(msg.sender != address(0), "invalid caller");
        EventStruct storage newEvent = events[_eventId];
        require(newEvent.eventId != 0, "invalid event id");
        
        
    }
} // 0x207De8361C16b18CA60b41F7D68A45B99E11d7A2