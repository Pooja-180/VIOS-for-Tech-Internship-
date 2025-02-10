// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LandRegistry {
    struct Land {
        uint256 id;
        string location;
        uint256 area;
        address owner;
        bool isRegistered;
    }

    mapping(uint256 => Land) public lands;
    mapping(address => uint256[]) public ownerLands;
    uint256 public landCount;

    event LandRegistered(uint256 id, address owner, string location, uint256 area);
    event OwnershipTransferred(uint256 id, address oldOwner, address newOwner);

    modifier onlyOwner(uint256 _landId) {
        require(lands[_landId].owner == msg.sender, "Not the owner");
        _;
    }

    function registerLand(string memory _location, uint256 _area) public {
        landCount++;
        lands[landCount] = Land(landCount, _location, _area, msg.sender, true);
        ownerLands[msg.sender].push(landCount);
        emit LandRegistered(landCount, msg.sender, _location, _area);
    }

    function transferOwnership(uint256 _landId, address _newOwner) public onlyOwner(_landId) {
        require(lands[_landId].isRegistered, "Land not registered");
        address oldOwner = lands[_landId].owner;
        lands[_landId].owner = _newOwner;
        emit OwnershipTransferred(_landId, oldOwner, _newOwner);
    }

    function getLandDetails(uint256 _landId) public view returns (string memory, uint256, address) {
        require(lands[_landId].isRegistered, "Land not registered");
        Land memory land = lands[_landId];
        return (land.location, land.area, land.owner);
    }
}
