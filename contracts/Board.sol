
pragma solidity ^0.6.12;

contract Board{
    struct plot{
        uint soil;
        uint sunlight;
        uint temperature;
        uint security;
        address renter;
        mapping(uint=>uint) PlantedSeeds;
    }
    uint decimals=10**18;
    uint totalSeedTypes=10;
    mapping(uint=> plot[4096]) farms;

    uint[] seedSoilAffinities;
    uint[] seedSproutAffinity;
    uint[] seedSunlightAffinities;

    uint[] seedPrices;

    constructor(uint[] memory _seedSoilAffinities,uint[] memory _seedSproutAffinity,uint[] memory _seedSunlightAffinities, uint[] memory _seedPrices) public {
        seedSoilAffinities= _seedSoilAffinities;
        seedSproutAffinity=_seedSproutAffinity;
        seedSunlightAffinities= _seedSunlightAffinities;
        
        seedPrices=_seedPrices;
    }

    function getFarmProperties(uint _plot,uint _game) public view returns(uint,uint,uint,uint,address){
        return (farms[_game][_plot].soil,farms[_game][_plot].sunlight,farms[_game][_plot].temperature,farms[_game][_plot].security,farms[_game][_plot].renter);
    }
    function getPlotPlantingProperties(uint _plot,uint _game) public view returns(uint,uint,uint){
        return (farms[_game][_plot].soil,farms[_game][_plot].sunlight,farms[_game][_plot].temperature);
    }

    function _plantSeeds(uint _plot,uint game,uint[] memory amounts,uint[] memory seeds) internal{
        plot storage p = farms[game][_plot];
        for(uint i=0;i<seeds.length;i++){
            p.PlantedSeeds[seeds[i]]=amounts[i];
        }
    }
    function calculateSeedScore(uint seed,uint _plot,uint game) public view returns(uint){
        (uint _soil,uint _sun,uint temp)=getPlotPlantingProperties(_plot,game);
        return absDiff(seedSoilAffinities[seed],_soil)+absDiff(seedSunlightAffinities[seed],_sun)+absDiff(seedSunlightAffinities[seed],temp);
    }
    function getRenter(uint _g,uint _p) public view returns(address){
        return farms[_g][_p].renter;
    }
    function getGrownRatio(uint seed,uint rv,uint score) public view returns(uint ratio){
        if(score>=10000){
            ratio=0;
        }else{
        uint ratio=rv%10000-score+seedSproutAffinity[seed];
        }
    }
    function getSeedGrowthResult(uint seed,uint _plot,uint quantity,uint game) public view returns(uint){
        uint score =calculateSeedScore(seed,_plot,game);
        uint growth= getGrownRatio(seed,getRandom(),score);
        return ((quantity*growth*decimals)/(20000*decimals));
    }

    function getAllPlotPlantedSeeds(uint game ,uint _plot) public view returns(uint[] memory seedlist,uint[] memory seedAmounts){
        plot storage pp=farms[game][_plot];
        for(uint i=0;i<totalSeedTypes;i++){
            if(pp.PlantedSeeds[i]>0){
                seedlist[i]=i;
                seedAmounts[i]=pp.PlantedSeeds[i];
            }
        }
    }

    function getTotalScore(uint plot,uint[] memory amounts,uint[] memory seeds,uint _game) public view returns(uint[] memory seedYield){
        for(uint i=0;i<seeds.length;i++){
            seedYield[i]=getSeedGrowthResult(seeds[i],plot,amounts[i],_game);
        }

    }
    function getRandom()  public view  returns(uint){
        return now;
    }

    function absDiff(uint a,uint b) public pure returns(uint Difference){
        if(a>b){
        Difference= (a-b);
        }else{
        Difference= (b-a);
        }
    }

}