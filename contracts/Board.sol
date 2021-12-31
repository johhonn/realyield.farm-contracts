pragma solidity ^0.6.12;

contract Board {
    struct plot {
        uint256 soil;
        uint256 sunlight;
        uint256 temperature;
        uint256 security;
        address renter;
        mapping(uint256 => uint256) PlantedSeeds;
    }
    uint256 decimals = 10**18;
    uint256 totalSeedTypes = 10;
    mapping(uint256 => plot[4096]) farms;

    uint256[] seedSoilAffinities;
    uint256[] seedSproutAffinity;
    uint256[] seedSunlightAffinities;

    uint256[] seedPrices;

    constructor(
        uint256[] memory _seedSoilAffinities,
        uint256[] memory _seedSproutAffinity,
        uint256[] memory _seedSunlightAffinities,
        uint256[] memory _seedPrices
    ) public {
        seedSoilAffinities = _seedSoilAffinities;
        seedSproutAffinity = _seedSproutAffinity;
        seedSunlightAffinities = _seedSunlightAffinities;

        seedPrices = _seedPrices;
    }

    function getFarmProperties(uint256 _plot, uint256 _game)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        return (
            farms[_game][_plot].soil,
            farms[_game][_plot].sunlight,
            farms[_game][_plot].temperature,
            farms[_game][_plot].security,
            farms[_game][_plot].renter
        );
    }

    function getPlotPlantingProperties(uint256 _plot, uint256 _game)
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return (
            farms[_game][_plot].soil,
            farms[_game][_plot].sunlight,
            farms[_game][_plot].temperature
        );
    }

    function _plantSeeds(
        uint256 _plot,
        uint256 game,
        uint256[] memory amounts,
        uint256[] memory seeds
    ) internal {
        plot storage p = farms[game][_plot];
        if (p.soil == 0) {
            setPlotProperties(game, _plot);
        }
        for (uint256 i = 0; i < seeds.length; i++) {
            p.PlantedSeeds[seeds[i]] = amounts[i];
        }
    }

    function calculateSeedScore(
        uint256 seed,
        uint256 _plot,
        uint256 game
    ) public view returns (uint256) {
        (uint256 _soil, uint256 _sun, uint256 temp) = getPlotPlantingProperties(
            _plot,
            game
        );
        return
            absDiff(seedSoilAffinities[seed], _soil) +
            absDiff(seedSunlightAffinities[seed], _sun) +
            absDiff(seedSunlightAffinities[seed], temp);
    }

    function getRenter(uint256 _g, uint256 _p) public view returns (address) {
        return farms[_g][_p].renter;
    }

    function getGrownRatio(
        uint256 seed,
        uint256 rv,
        uint256 score
    ) public view returns (uint256 ratio) {
        if (score >= 10000) {
            ratio = 0;
        } else {
            uint256 ratio = (rv % 10000) - score + seedSproutAffinity[seed];
        }
    }

    function getSeedGrowthResult(
        uint256 seed,
        uint256 _plot,
        uint256 quantity,
        uint256 game
    ) public view returns (uint256) {
        uint256 score = calculateSeedScore(seed, _plot, game);
        uint256 growth = getGrownRatio(seed, getLatestRandom(), score);
        return ((quantity * growth * decimals) / (20000 * decimals));
    }

    function getAllPlotPlantedSeeds(uint256 game, uint256 _plot)
        public
        view
        returns (uint256[] memory, uint256[] memory)
    {
        plot storage pp = farms[game][_plot];
        uint256[] memory seedlist = new uint256[](totalSeedTypes);
        uint256[] memory seedAmounts = new uint256[](totalSeedTypes);
        for (uint256 i = 0; i < totalSeedTypes; i++) {
            if (pp.PlantedSeeds[i] > 0) {
                console.log(i);
                console.log(pp.PlantedSeeds[i]);
                seedlist[i] = i;
                seedAmounts[i] = pp.PlantedSeeds[i];
            }
        }
        return (seedlist, seedAmounts);
    }

    function getTotalScore(
        uint256 plot,
        uint256[] memory amounts,
        uint256[] memory seeds,
        uint256 _game
    ) public view returns (uint256[] memory) {
        uint256[] memory seedYield = new uint256[](totalSeedTypes);
        for (uint256 i = 0; i < seeds.length; i++) {
            seedYield[i] = getSeedGrowthResult(
                seeds[i],
                plot,
                amounts[i],
                _game
            );
        }
    }

    function getLatestRandom() public view returns (uint256) {
        return getRandom(now);
    }

    function getRandom(uint256 seed) public view returns (uint256) {
        return
            uint256(keccak256(abi.encodePacked(block.difficulty, now, seed)));
    }

    function setPlotProperties(uint256 _game, uint256 _plot) internal {
        uint256 r = getRandom(_game * _plot);
        plot storage p = farms[_game][_plot];
        p.soil = 1000 + (r % 5000);
        p.sunlight = 1000 + (((r % 5000)**2) % 5000);
        p.temperature = 1000 + (((r % 5000)**3) % 5000);
        p.security = 1000 + (((r % 5000)**4) % 5000);
    }

    function absDiff(uint256 a, uint256 b)
        public
        pure
        returns (uint256 Difference)
    {
        if (a > b) {
            Difference = (a - b);
        } else {
            Difference = (b - a);
        }
    }
}
