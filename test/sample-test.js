const { expect } = require("chai");
const { ethers } = require("hardhat");
const { parseEther, parseUnits } = require("ethers/lib/utils");

describe("Aave Flashloan Test", function () {
  let owner;
  let flashloan;

  const daiAddress = "0x6b175474e89094c44da98b954eedeac495271d0f";

  beforeEach(async () => {
    const flashloanContractFactory = await ethers.getContractFactory(
      "AaveFlashloan"
    );
    [owner] = await ethers.getSigners();
    flashloan = await flashloanContractFactory.deploy();
  });

  describe("Flashloan Test",  async () => {
    let Dai, aDai;
      beforeEach(async () => {
        const tokenArtifact = await artifacts.readArtifact("IERC20");
        Dai = new ethers.Contract(daiAddress, tokenArtifact.abi, ethers.provider);
        await Dai.connect(owner).approve(
          flashloan.address,
          10000
        );
      });
        
        describe("Take loan",  async () => {
          const assets = [Dai];
          const amounts = [10000];
          const modes = [0];
          const premiums = [9];

          it("Check balance",  async () => {
            await flashloan.myFlashLoanCall(assets,amounts,modes,0)
          
            await flashloan.executeOperation(assets,amounts,premiums,"","")

          await expect(await flashloan.getBalance(Dai)).to.eq(9991);
          });
        })
  })
});