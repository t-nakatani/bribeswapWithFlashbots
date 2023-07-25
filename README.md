# BribeSwap Contract (Testnet Version)

`BribeSwap` is a smart contract specifically designed for the Ethereum testnet, particularly Goerli. On the Ethereum network, a unique approach allows for the creation of "bundles" of transactions. By submitting these bundles to Flashbots' relay, multiple transactions can be executed in a consolidated manner. A critical component of this process is the ability to provide bribes to validators. When these validators receive bribes, they are incentivized to include the bundle in the block they're proposing. This mechanism ensures that certain transactions get priority, and BribeSwap has been tailored to leverage this technique efficiently on the Goerli testnet.

## ⚠️ Not Finalcial Advice

Please note that this contract is meant for testnet use only. It is **Not Finalcial Advice** . Make sure to conduct thorough testing and auditing if planning to use a similar contract on mainnet.

## Features

1. **Admin Management**:
   - Only the owner can add or remove an admin.
   - Admins have the privilege to invoke token recovery and swapping functions.

2. **Token Recovery**:
   - Admins can recover any ERC20 tokens sent mistakenly to the contract.
   - Supports ETH recovery as well.

3. **Token Swapping**:
   - Supports swapping WETH for any ERC20 token.
   - Swaps any ERC20 token for WETH.
   - Admins can set a minimum desired output for swaps and a bribe ratio for the swap function which interacts with the validator.

## Dependencies

- **IUniswapV2Router02**: For interacting with the Uniswap V2 router.
- **IERC20**: Interface for ERC20 compliant tokens.
- **IWETH**: Interface for Wrapped Ethereum (WETH) functions.

## Setup and Deployment

### Prerequisites

- [Hardhat](https://hardhat.org/)
- An Ethereum wallet with sufficient ETH (for deployment and gas fees)
- Access to Ethereum testnets

### Steps

1. Clone the repository.
2. Install dependencies:

   ```bash
   npm install
   ```

3. Create a `.env` file and set the variables `JSON_RPC` and `PRIVATE_KEY`:

   ```
   JSON_RPC=YOUR_JSON_RPC_URL
   PRIVATE_KEY=YOUR_ETHEREUM_PRIVATE_KEY
   ```

4. Compile the contract:

   ```bash
   npx hardhat compile
   ```

5. Deploy the contract:

   ```bash
   npx hardhat run scripts/deploy.js --network goerli
   ```

   *Note: Replace `goerli` with the desired testnet.*

6. Interact with the contract using the deployed address and ABI from the artifacts directory.

## License

MIT
