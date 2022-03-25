// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@rari-capital/solmate/src/tokens/ERC20.sol";
import "hardhat/console.sol";

contract Building {
    enum BuildingType {
        METALMINE,
        CRYSTALMINE,
        DEUTEREUMSYNTHESIZOR
    }
    BuildingType public buildingType;

    struct PlayerBuilding {
        address playerAddress;
        BuildingType buildingType;
        uint256 level;
    }

    struct LevelInfo {
        uint256 costMetal;
        uint256 costCrystal;
        uint256 costDeutereum;
        uint256 productionRate;
    }

    mapping(string => uint256) public levels;
    mapping(address => PlayerBuilding[]) public buildings;
    mapping(BuildingType => LevelInfo[]) public resourcesLevelInfo;

    function getProductionRate(address user, BuildingType _buildingType)
        public
        view
        returns (uint256)
    {
        PlayerBuilding memory building = buildings[user][uint(_buildingType)];
        return resourcesLevelInfo[_buildingType][building.level].productionRate;
    }

    LevelInfo[2] public linfo;
    PlayerBuilding building1;

    function init(address userAddress) external {
        linfo[0] = LevelInfo({
            costMetal: 100,
            costCrystal: 100,
            costDeutereum: 0,
            productionRate: 1
        });
        linfo[1] = LevelInfo({
            costMetal: 200,
            costCrystal: 200,
            costDeutereum: 0,
            productionRate: 2
        });
        resourcesLevelInfo[BuildingType.METALMINE] = linfo;
        MetalERC20 merc = new MetalERC20("Metal", "Metal", 18, address(this));
        PlayerBuilding memory building = PlayerBuilding({
            playerAddress: userAddress,
            buildingType: BuildingType.METALMINE,
            level: 0
        });
        //PlayerBuilding building = PlayerBuilding({playerAddress:userAddress,BuildingType:BuildingType.METALMINE,level:0});

        //    PlayerBuilding[3] memory pbs = [building,building,building];
        //   buildings[userAddress] = [PlayerBuilding({BuildingType:BuildingType.METALMINE,level:0})];
        //add to erc20 mappings, balance and lastUpdate
    }

    constructor() {}
}

contract MetalERC20 is ERC20 {
    Building building;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address _BuildingContractAddress
    ) ERC20(name, symbol, decimals) {
        _mint(msg.sender, decimals);
        building = Building(_BuildingContractAddress);
    }

    mapping(address => uint256) balanceMetal;
    mapping(address => uint256) lastUpdate;

    function updateBalance(address userAddress) internal {
        uint256 rate = building.getProductionRate(userAddress, Building.BuildingType.METALMINE);
        balanceMetal[userAddress] += (block.timestamp - lastUpdate[userAddress]) * rate;
        lastUpdate[userAddress] = block.timestamp;
    }
}
