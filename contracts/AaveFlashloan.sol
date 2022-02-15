// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./interfaces/Loan.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AaveFlashloan is IFlashLoanReceiver {
     address private owner;
     LendingPool LENDING_POOL;
     
    constructor(){
     LENDING_POOL =  LendingPool(
            address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9)
        );  
      owner = msg.sender;
    }
   
   function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    )
        external
        override
        returns (bool)
    {

        //
        // This contract now has the funds requested.
        // Your logic goes here.
        //
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.
        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i] + premiums[i];
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

         IERC20 token = IERC20(assets[0]);
         uint256 contractBalance = token.balanceOf(address(this));
        console.log(contractBalance);
        
        return true;
    }

      function getBalance(address asset) external view returns (uint256) {
         IERC20 token = IERC20(asset);
         uint256 contractBalance = token.balanceOf(address(this));
        console.log(contractBalance);
        return contractBalance;
    }
    
    function myFlashLoanCall(address[] memory assets ,uint256[] memory amounts,uint256[] memory modes, uint16 referralCode) public {
        address receiverAddress = address(this);

        address onBehalfOf = address(this);
        bytes memory params = "";

        IERC20 token = IERC20(assets[0]);
        token.transferFrom(msg.sender, address(this),amounts[0]);

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
        //console.log("check");
    }
}
