// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IUniswapV2Router02.sol';
import './IERC20.sol';
import './IWETH.sol';

contract BribeSwap {
    address private owner;
    address routerV2;
    address WETH;
    mapping(address => bool) private admins;

    constructor(address _router, address _WETH) {
        owner = msg.sender;
        routerV2 = _router;
        WETH = _WETH;
        admins[msg.sender] = true;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Not authorized");
        _;
    }

    function addAdmin(address _admin) external {
        require(msg.sender == owner, "Only owner can add an admin");
        require(!admins[_admin], "Address is already an admin");
        admins[_admin] = true;
    }
    
    function removeAdmin(address _admin) external {
        require(msg.sender == owner, "Only owner can remove an admin");
        require(admins[_admin], "Address is not an admin");
        admins[_admin] = false;
    }

    function recoverTokens(address tokenAddress) external onlyAdmin {
        if (tokenAddress == address(0)) {
            payable(msg.sender).transfer(address(this).balance);
        } else {
            uint256 balance = IERC20(tokenAddress).balanceOf(address(this));
            IERC20(tokenAddress).transfer(msg.sender, balance);
        }
    }

    function swapExactWETHForTokens(address tokenOut, uint256 amountIn) external payable onlyAdmin {

        require(msg.value == amountIn, "Sent ETH amount does not match specified amountIn");
        IWETH(WETH).deposit{value: amountIn}();

        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = tokenOut;

        uint256 currentAllowance = IERC20(WETH).allowance(address(this), routerV2);
        if (currentAllowance < amountIn) {
            IERC20(WETH).approve(routerV2, type(uint256).max); // 最大値をapprove
        }

        IUniswapV2Router02(routerV2).swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp);
    }

    function swapAllTokensForWETH(address tokenIn, uint256 amountOutMin, uint256 bribeRatio) external onlyAdmin {
        require(0 <= bribeRatio && bribeRatio <= 100, "Invalid bribeRatio");

        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = WETH;

        uint256 BalancetokenIn = IERC20(tokenIn).balanceOf(address(this));
        uint256 currentAllowance = IERC20(tokenIn).allowance(address(this), routerV2);
        if (currentAllowance < BalancetokenIn) {
            IERC20(tokenIn).approve(routerV2, type(uint256).max); // 最大値をapprove
        }
        
        uint256 amountOut = IUniswapV2Router02(routerV2).swapExactTokensForTokens(BalancetokenIn, amountOutMin, path, address(this), block.timestamp)[1];
        require(amountOut > amountOutMin, "amountOut <= amountOutMin");

        IWETH(WETH).withdraw(amountOut);
        uint256 amountBribe = (amountOut - amountOutMin) * bribeRatio / 100;

        // send to signer
        payable(msg.sender).transfer(address(this).balance - amountBribe);

        // send to validator
        block.coinbase.transfer(amountBribe);
    }
}
