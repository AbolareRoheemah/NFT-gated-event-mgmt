// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Event {
    uint eventCount;
    address owner;
    struct EventStruct {
       string name;
       uint eventId;
       uint startAt;
       uint endAt;
       bool isCompleted;
       address eventNFT;
       uint nftId;
       uint noOfRegisteredAttendees; 
       address[] registeredAttendees;
    }

    constructor (address _owner) {
        owner = _owner;
    }

    EventStruct[] allEvents;
    mapping (uint => EventStruct) events;

    event EventCreated(string name, uint startAt, uint endAt);
    event ApplicantRegistered(uint indexed eventId, address indexed applicant);

    function createEvent(address _nftAddress, string memory _name, uint _nftId, uint _startAt, uint _endAt) external {
        require(msg.sender != address(0), "invalid caller");
        require(msg.sender == owner, "not authorized");
        require(_nftAddress != address(0), "invalid nft address");
        require(_startAt >= block.timestamp, "invalid start time");

        uint newCount = eventCount + 1;
        EventStruct storage newEvent = events[newCount];
        newEvent.name = _name;
        newEvent.eventId = newCount;
        newEvent.eventNFT = _nftAddress;
        newEvent.nftId = _nftId;
        newEvent.startAt = _startAt;
        newEvent.endAt = _endAt;

        allEvents.push(newEvent);
        eventCount = newCount;

        emit EventCreated(_name, _startAt, _endAt);
    }

    function attendeeReg(uint _eventId, address _applicant) external {
        require(msg.sender != address(0), "invalid caller");
        require(_applicant != address(0), "invalid applicant address");
        EventStruct storage newEvent = events[_eventId];
        require(newEvent.eventId != 0, "invalid event id");
        require(newEvent.endAt > block.timestamp, "event has ended");
        require(newEvent.startAt <= block.timestamp, "event hasnt started");
        require(IERC721(newEvent.eventNFT).balanceOf(_applicant) > 0, "required NFT not found");
        
        newEvent.registeredAttendees.push(_applicant);
        newEvent.noOfRegisteredAttendees++;

        emit ApplicantRegistered(_eventId, _applicant);
    }

    function mintEventNFT(address _to, address _nftAddress, uint256 _tokenId) internal {
        require(msg.sender == owner, "not authorized");
        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == address(this), "Contract doesn't own the NFT");
        nft.safeTransferFrom(address(this), _to, _tokenId);
    }
} // 0x207De8361C16b18CA60b41F7D68A45B99E11d7A2