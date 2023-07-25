async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Contract = await ethers.getContractFactory("BribeSwap");
    const contract = await Contract.deploy(
      '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',  // router
      '0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6',  // WETH
    );
  
    console.log("contract address:", contract.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  