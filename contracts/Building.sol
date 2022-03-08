// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@rari-capital/solmate/src/tokens/ERC20.sol";

contract Building {

  enum BuildingType{ METALMINE, CRYSTALMINE, DEUTEREUMSYNTHESIZOR }
   BuildingType public buildingType = BuildingType.METALMINE;
   
  struct PlayerBuilding {
    address playerAddress;
    BuildingType buildingType;
    uint level;
  } 
  
  struct LevelInfo {
    uint256 costMetal;
    uint256 costCrystal;
    uint256 costDeutereum;
    uint256 productionRate;
  }
  
  mapping( string => uint256 ) public levels;
  mapping( BuildingType => LevelInfo[] ) public resourcesLevelInfo;
  
  function init() external {
  //  LevelInfo[] memory lia  = new LevelInfo[](1);
 //   lia[0] = LevelInfo( 100, 100, 0, 1 );
  //  resourcesLevelInfo[BuildingType.METALMINE] = lia;
  }
  
  constructor() {
        
  }
  
}

contract MetalERC20 is ERC20 {
 
  Building building;

  constructor(string memory name, string memory symbol, uint8 decimals, address _BuildingContractAddress ) ERC20(name, symbol, decimals) {
    _mint(msg.sender, decimals);
    building = Building(_BuildingContractAddress);
  }
  
  mapping(address =>uint) balanceMetal;
  mapping(address =>uint) lastUpdate;

  function updateBalance(address userAddress) internal {
   uint rate = building.resourcesLevelInfo(building.buildingType.METALMINE)[0].productionRate;
 //  balanceMetal[userAddress] += ( block.timestamp - lastUpdate[userAddress] ) * rate;
   lastUpdate[userAddress] = block.timestamp;
  }
}
