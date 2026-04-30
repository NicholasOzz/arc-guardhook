# Arc GuardHook - Real-time Security Hook

**Gotchipus GuardHook for Arc** — A real-time security hook designed to stop scammers instantly on **Arc** (Circle's stablecoin-native Layer 1 blockchain).

Built with **Foundry** and fully open-source, just like the original version on Pharos Network (Atlantic testnet).

---

## ✨ Features

- Real-time transaction guarding with instant revert on suspicious activity
- Blacklist management for known scam addresses
- Transfer amount limits and cooldown protection
- Velocity / spam protection
- `validateTx()` function for off-chain agents and wallets to check transactions before execution
- Non-reentrant secure transfer wrapper
- Fully compatible with native **USDC** (gas token on Arc)
- Modular design — easy to extend with reputation oracles, ERC-4337 validation, or Gotchipus dNFT integration

---

## 🛠 Tech Stack

- **Solidity** ^0.8.24
- **Foundry** (recommended)
- OpenZeppelin Contracts
- EVM-compatible (Arc Testnet)

---

## 📍 Network Details (Arc Testnet)

- **Network Name**: Arc Testnet
- **RPC URL**: `https://rpc.testnet.arc.network`
- **Chain ID**: `5042002`
- **Currency**: USDC (native gas token)
- **Block Explorer**: [https://testnet.arcscan.app](https://testnet.arcscan.app)
- **Faucet**: [https://faucet.circle.com](https://faucet.circle.com)

---

## 🚀 Quick Start

### 1. Clone & Install
```bash
git clone https://github.com/NicholasOzz/arc-guardhook.git
cd arc-guardhook
forge installv.
