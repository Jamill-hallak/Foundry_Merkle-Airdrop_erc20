# Merkle Airdrop Extravaganza

This repository, **[Foundry_Merkle-Airdrop_erc20](https://github.com/Jamill-hallak/Foundry_Merkle-Airdrop_erc20.git)**, is part of the **Cyfrin Updraft Advanced Foundry Course**, where we dive deep into **signatures**, **merkle drops**, and advanced blockchain development concepts. This project was created as part of my learning journey to master blockchain technology.

---

## 🚀 Overview

This project focuses on:
- **Generating merkle proofs** for airdrops.
- **Deploying contracts** to local Anvil and zkSync networks.
- **Interacting** with deployed contracts for airdrop claims.
- **Testing and gas estimation** to ensure optimal performance.
- **Formatting and best practices** for solidity projects.

This repository demonstrates advanced blockchain development concepts that emphasize **efficiency**, **security**, and **real-world applications**.

---

## 🛠️ Getting Started

### Requirements

Ensure you have the following tools installed:
- **Git**: Verify with `git --version`.
- **Foundry**: Verify with `forge --version` (recommended version: `forge 0.2.0`).
- **NPM & NPX**: Verify with `npm --version` and `npx --version`.
- **Docker**: Verify with `docker --version`.

### Quickstart

Clone the repository and set up the environment:
```bash
git clone https://github.com/Jamill-hallak/Foundry_Merkle-Airdrop_erc20.git
cd Foundry_Merkle-Airdrop_erc20
make # or run `forge install && forge build` if you don't have make installed
```

---

## 📦 Usage

### Pre-deploy: Generate Merkle Proofs

Generate merkle proofs for the whitelist addresses:

1. Update the array of addresses in `GenerateInput.s.sol`.
2. Generate the input file and merkle proofs:
   ```bash
   make merkle
   ```
   Alternatively:
   ```bash
   forge script script/GenerateInput.s.sol:GenerateInput && forge script script/MakeMerkle.s.sol:MakeMerkle
   ```

3. Retrieve the `merkleRoot` from `script/target/output.json` and update:
   - **`Makefile`**: For zkSync deployments.
   - **`DeployMerkleAirdrop.s.sol`**: For Ethereum/Anvil deployments.

---

## 🚀 Deployment

### Deploy to Anvil
```bash
foundryup
make anvil
make deploy
```

### Deploy to zkSync Local Node

1. Set up zkSync tools:
   ```bash
   foundryup-zksync
   ```

2. Run a local zkSync node:
   ```bash
   npx zksync-cli dev config
   npx zksync-cli dev start
   ```

3. Deploy the contracts:
   ```bash
   make deploy-zk
   ```

---

## 📝 Interactions

### Claim Airdrop (Local zkSync Network)

1. Set up and deploy contracts:
   ```bash
   chmod +x interactZk.sh && ./interactZk.sh
   ```

2. Follow the script output to:
   - Deploy zkSync contracts.
   - Sign the airdrop claim.
   - Execute the airdrop claim.

### Claim Airdrop (Local Anvil Network)

1. Deploy contracts:
   ```bash
   foundryup
   make anvil
   make deploy
   ```

2. Sign and claim the airdrop:
   ```bash
   make sign
   make claim
   ```

3. Verify the claim:
   ```bash
   make balance
   ```

---

## 🧪 Testing

### Run Tests
```bash
foundryup
forge test
```

For zkSync:
```bash
make zktest
```

### Estimate Gas
```bash
forge snapshot
```

---

## 🛠️ Formatting

Format code to adhere to best practices:
```bash
forge fmt
```

---

## 🎓 Acknowledgements

This project is part of the **Cyfrin Updraft Advanced Foundry Course**. Special thanks to **Cyfrin** for providing this incredible learning opportunity.

As part of my journey, I have customized and implemented advanced blockchain concepts to better understand **Merkle proofs**, **airdrop mechanisms**, and **zkSync integration**.

---

