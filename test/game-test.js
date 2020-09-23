const { expect } = require("chai");

describe("Game Test", function() {
  it("Should deploy Game contract then Calculate first Game Time", async function() {
    const game = await ethers.getContractFactory("Game");
    const token = await ethers.getContractFactory("yieldToken");
    const Token=await token.deploy();
    console.log(Token.address)
    let now=Math.round(new Date().getTime()/1000);
   let _allocation=[10,10,10,10,10,10,10,10,10,10]
   let _limits=[1000,1000,1000,1000,1000,1000,1000,1000,1000,1000]
   let _deposit=10**18 
   let _gameinterval=600;
   let _first_game= now;
   let _seedSoilAffinities =[1000,2000,3000,4000,3000,2000,4000,3000,2000,1000]
   let  _seedSproutAffinity =[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]
   let _seedSunlightAffinities=[1000,2000,3000,4000,3000,2000,4000,3000,2000,1000]
   let _seedPrices=[10,20,30,40,50,60,70,80,90,100]

    const Game = await game.deploy(_allocation,_limits,_deposit,_gameinterval,_first_game,_seedSoilAffinities,_seedSproutAffinity,_seedSunlightAffinities,_seedPrices);
    let next=await Game.getNextGame()
    console.log(`current time is ${now} and  next game is ${next.toString()}`)
    let diff=next.toString()-now;
    expect(diff).to.equal(600)
    let encodedCrop=next*100000
    let wei = ethers.utils.parseEther('10000');
    let interestRates=[10,20,30,40]
    let yield=await Game.getYield(encodedCrop,wei,interestRates,[100,100,100,100],10)
    let yield1=await Game.getYield(encodedCrop+1,wei,interestRates,[100,100,100,100],10) 
    let yield2=await Game.getYield(encodedCrop+2,wei,interestRates,[100,100,100,100],10)
    let yield3=await Game.getYield(encodedCrop+3,wei,interestRates,[100,100,100,100],10)      
    
   // let wei = utils.parseEther('10000');
    let parsed=ethers.utils.formatEther(yield.toString());
    let parsed1=ethers.utils.formatEther(yield1.toString());
    let parsed2=ethers.utils.formatEther(yield2.toString());
    let parsed3=ethers.utils.formatEther(yield3.toString());
    console.log(parsed)
    console.log(parsed1)
    console.log(parsed2)
    console.log(parsed3)
  });
});
