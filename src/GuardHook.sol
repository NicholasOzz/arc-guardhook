// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Arc GuardHook
 * @notice Real-time security hook to stop scammers instantly on Arc Network
 * @dev Inspired by Gotchipus GuardHook on Pharos Network (Atlantic)
 */
contract GuardHook is Ownable, ReentrancyGuard {
    
    IERC20 public immutable usdc;

    mapping(address => bool) public blacklisted;
    mapping(address => uint256) public lastTxTimestamp;
    
    uint256 public maxTransferAmount = 10_000 * 1e6; // 10,000 USDC
    uint256 public cooldownPeriod = 60 seconds;     // Anti-spam cooldown

    event ScamAttemptBlocked(address indexed from, address indexed to, uint256 amount, string reason);
    event BlacklistUpdated(address indexed account, bool status);
    event GuardConfigUpdated(string param, uint256 value);

    constructor(address _usdc) Ownable(msg.sender) {
        require(_usdc != address(0), "Invalid USDC address");
        usdc = IERC20(_usdc);
    }

    modifier guarded(address to, uint256 amount) {
        require(!blacklisted[msg.sender] && !blacklisted[to], "Address blacklisted");
        require(block.timestamp >= lastTxTimestamp[msg.sender] + cooldownPeriod, "Cooldown active");
        require(amount <= maxTransferAmount, "Exceeds max transfer amount");
        _;
        lastTxTimestamp[msg.sender] = block.timestamp;
    }

    /**
     * @notice Secure USDC transfer with real-time guard checks
     */
    function secureTransfer(address to, uint256 amount) 
        external 
        guarded(to, amount) 
        nonReentrant 
    {
        usdc.transferFrom(msg.sender, to, amount);
    }

    /**
     * @notice Validate transaction before execution (useful for agents/wallets)
     */
    function validateTx(address from, address to, uint256 amount) 
        external 
        view 
        returns (bool isValid, string memory reason) 
    {
        if (blacklisted[from] || blacklisted[to]) {
            return (false, "Address blacklisted");
        }
        if (amount > maxTransferAmount) {
            return (false, "Amount exceeds limit");
        }
        if (block.timestamp < lastTxTimestamp[from] + cooldownPeriod) {
            return (false, "Cooldown period active");
        }
        return (true, "Transaction valid");
    }

    // ========== Admin Functions ==========
    function blacklist(address account, bool status) external onlyOwner {
        blacklisted[account] = status;
        emit BlacklistUpdated(account, status);
    }

    function updateMaxTransferAmount(uint256 newAmount) external onlyOwner {
        maxTransferAmount = newAmount;
        emit GuardConfigUpdated("maxTransferAmount", newAmount);
    }

    function updateCooldown(uint256 newCooldown) external onlyOwner {
        cooldownPeriod = newCooldown;
        emit GuardConfigUpdated("cooldownPeriod", newCooldown);
    }

    // Emergency withdraw (in case of issues)
    function emergencyWithdraw(uint256 amount) external onlyOwner {
        usdc.transfer(owner(), amount);
    }
}
