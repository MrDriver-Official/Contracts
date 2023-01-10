// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Lib/Ownable.sol";
import "./Lib/SafeMath.sol";
import "./Interface/IBEP20.sol";
import "./Referral.sol";
import "./Lib/ReentrancyGuard.sol";

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract MDRPresale is Ownable, Referral, ReentrancyGuard {
    using SafeMath for uint256;

    IBEP20 public MDR;
    
    uint256 public startDate = 1669177000;                  // 2022/11/25 02:00:00 UTC
    uint256 public endDate = 1669180000;                    // 2022/12/9 02:00:00 UTC
    uint256 public lockDate = 1641427200;                    // 2022/1/6 00:00:00 UTC
    
    uint256 public totalTokensToSell = 50000000 * 10**18;   // 50000000 MDR tokens for sell
    uint256 public mdrPerBusd = 10 * 10**18;                // 1 Busd = 10 MDR
    uint256 public minPerTransaction = 1000 * 10**18;        // min amount per transaction (1000 MDR / 100 BUSD)
    uint256 public maxPerUser = 20000 * 10**18;              // max amount per user (20000 MDR / 2000 BUSD)
    uint256 public totalSold;

    IUniswapV2Router02 public  uniswapV2Router;
    address public  uniswapV2Pair;

    bool public saleEnded;
    
    mapping(address => uint256) public mdrPerAddresses;

    event tokensBought(address indexed user, uint256 amountSpent, uint256 amountBought, string tokenName, uint256 date);
    event tokensClaimed(address indexed user, uint256 amount, uint256 date);
    event addLiquidityEvent(uint256 tokenAmount, uint256 ethAmount, uint256 allowance);

    modifier checkSaleRequirements(uint256 buyAmount) {
        require(now >= startDate && now < endDate, 'MDR Presale time passed');
        require(saleEnded == false, 'Sale ended');
        require(
            buyAmount > 0 && buyAmount <= unsoldTokens(),
            'Insufficient buy amount'
        );
        _;
    }

    modifier checkWithdrawLPRequirements() {
        require(now >= lockDate, 'LP is locked.');
        require(saleEnded == true, 'Sale not finished.');
        _;
    }

    address public adminWallet;
    address public stakePool;

    uint256 public stakePoolRate = 1000; // 10%
    uint256 public liquidityRate = 4000; // 40%

    constructor(
        address _MDR,
        address _BUSD,
        uint _decimals,
        uint _referralBonus,
        uint _secondsUntilInactive,
        bool _onlyRewardActiveReferrers,
        uint256[] memory _levelRate,
        uint256[] memory _refereeBonusRateMap
    ) Referral (
        _BUSD,
        _decimals,
        _referralBonus,
        _secondsUntilInactive,
        _onlyRewardActiveReferrers,
        _levelRate,
        _refereeBonusRateMap
    ) public {
        MDR = IBEP20(_MDR);
    }

    // Function to buy MDR using BUSD token
    function buyWithBUSD(uint256 buyAmount, address referrer) public nonReentrant checkSaleRequirements(buyAmount) {
        require(adminWallet != address(0), "Presale: admin address is not valid.");
        require(stakePool != address(0), "Presale: stake pool is not valid.");
        require(referrer != address(0), "Presale: referrer is not valid.");

        uint256 amount = calculateBUSDAmount(buyAmount);
        require(BUSD.balanceOf(msg.sender) >= amount, 'Insufficient BUSD balance');
        require(buyAmount >= minPerTransaction, 'Lower than the minimal transaction amount');
        
        uint256 sumSoFar = mdrPerAddresses[msg.sender].add(buyAmount);
        require(sumSoFar <= maxPerUser, 'Greater than the maximum purchase limit');

        // receive BUSD
        BUSD.transferFrom(address(msg.sender), address(this), amount);

        if( referrer != address(msg.sender) ) {
            if(!hasReferrer(msg.sender)){
                addReferrer(referrer);
            }
        }

        // pay referral
        payReferral(amount);

        uint256 stakePoolAmount = amount * stakePoolRate / decimals;
        uint256 liquidityAmount = amount * liquidityRate / decimals;

        // send BUSD to stakePool
        BUSD.transfer(stakePool, stakePoolAmount);

        // add Liquidity
        addLiquidity(MDR.balanceOf(address(this)) / 10, liquidityAmount);

        // send BUSD to admin
        BUSD.transfer(adminWallet, BUSD.balanceOf(address(this)));

        mdrPerAddresses[msg.sender] = sumSoFar;
        totalSold = totalSold.add(buyAmount);
        
        MDR.transfer(msg.sender, buyAmount);
        emit tokensBought(msg.sender, amount, buyAmount, 'BUSD', now);
    }

    // function to set the presale start date
    function setStartDate(uint256 _startDate) public onlyOwner {
        require(_startDate < endDate);
        startDate = _startDate;
    }

    // function to set the presale end date
    function setEndDate(uint256 _endDate) public onlyOwner {
        require(_endDate > startDate);
        endDate = _endDate;
    }

    // function to set the presale end date
    // only owner can call this function
    function setLockDate(uint256 _lockDate) public onlyOwner {
        require(saleEnded == false);
        lockDate = _lockDate;
    }

    // function to set the total tokens to sell
    function setTotalTokensToSell(uint256 _totalTokensToSell) public onlyOwner {
        totalTokensToSell = _totalTokensToSell;
    }

    // function to set the minimal transaction amount
    function setMinPerTransaction(uint256 _minPerTransaction) public onlyOwner {
        minPerTransaction = _minPerTransaction;
    }

    // function to set the maximum amount which a user can buy
    function setMaxPerUser(uint256 _maxPerUser) public onlyOwner {
        maxPerUser = _maxPerUser;
    }

    // function to set the total tokens to sell
    function setTokenPricePerBUSD(uint256 _mdrPerBusd) public onlyOwner {
        require(_mdrPerBusd > 0, "Invalid MDR price per BUSD");
        mdrPerBusd = _mdrPerBusd;
    }

    //function to end the sale
    function endSale() public onlyOwner {
        require(saleEnded == false);
        saleEnded = true;
    }

    //function to withdraw unsold tokens
    function withdrawUnsoldTokens() public onlyOwner {
        uint256 remainedTokens = unsoldTokens();
        require(remainedTokens > 0, "No remained tokens");
        MDR.transfer(owner(), remainedTokens);
    }

    //function to withdraw locked lp tokens
    function withdrawLockedLPTokens() public onlyOwner checkWithdrawLPRequirements{
        uint256 lockedLPTokens = lockedLPTokens();
        require(lockedLPTokens > 0, "No locked LP tokens");

        IUniswapV2Pair(uniswapV2Pair).transfer(adminWallet, lockedLPTokens);
    }

    //function to return the amount of unsold tokens
    function unsoldTokens() public view returns (uint256) {
        // return totalTokensToSell.sub(totalSold);
        return MDR.balanceOf(address(this));
    }

    //function to return the amount of unsold tokens
    function lockedLPTokens() public view returns (uint256) {
        // return totalTokensToSell.sub(totalSold);
        return IUniswapV2Pair(uniswapV2Pair).balanceOf(address(this));
    }

    //function to calculate the quantity of MDR token based on the MDR price of busdAmount
    function calculateMDRAmount(uint256 busdAmount) public view returns (uint256) {
        uint256 mdrAmount = mdrPerBusd.mul(busdAmount).div(10**18);
        return mdrAmount;
    }

    //function to calculate the quantity of bnb needed using its MDR price to buy `buyAmount` of MDR tokens.
    function calculateBUSDAmount(uint256 mdrAmount) public view returns (uint256) {
        require(mdrPerBusd > 0, "MDR price per BUSD should be greater than 0");
        uint256 busdAmount = mdrAmount.mul(10**18).div(mdrPerBusd);
        return busdAmount;
    }

    function setRouter(address _router) public onlyOwner{
        require(saleEnded == false);
        IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(_router);

        if (IUniswapV2Factory(_newPancakeRouter.factory()).getPair(address(MDR), address(BUSD)) == address(0)) {
            uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory()).createPair(address(MDR), address(BUSD));
        } else {
            uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory()).getPair(address(MDR), address(BUSD));
        }
        
        uniswapV2Router = _newPancakeRouter;
    }

    function addLiquidity(uint256 tokenAmount, uint256 busdAmount) private {
        // approve token transfer to cover all possible scenarios
        MDR.approve(address(uniswapV2Router), tokenAmount);
        BUSD.approve(address(uniswapV2Router), busdAmount);
        uint256 allowance = MDR.allowance(address(this), address(uniswapV2Router));
        
        emit addLiquidityEvent(tokenAmount, busdAmount, allowance);

        // add the liquidity
        uniswapV2Router.addLiquidity(
            address(MDR),
            address(BUSD),
            tokenAmount,
            busdAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    function updateAdminWallet(address _adminWallet) public onlyOwner {
        require(_adminWallet != address(0), "Presale: Invalid address.");
        adminWallet = _adminWallet;
    }

    function updateStakePool(address _stakePool) public onlyOwner {
        require(_stakePool != address(0), "Presale: Invalid address.");
        stakePool = _stakePool;
    }

    function updateStakePoolRate(uint256 _stakePoolRate) public onlyOwner {
        require(_stakePoolRate < decimals, "Presale: Rate is not valid");
        stakePoolRate = _stakePoolRate;
    }

    function updateLiquidityRate(uint256 _liquidityRate) public onlyOwner {
        require(_liquidityRate < decimals, "Presale: Rate is not valid");
        liquidityRate = _liquidityRate;
    }

}