import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys a contract named "YourContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  /*
    On localhost, the deployer account is the one that comes with Hardhat, which is already funded.

    When deploying to live networks (e.g `yarn deploy --network goerli`), the deployer account
    should have sufficient balance to pay for the gas fees for contract creation.

    You can generate a random account with `yarn generate` which will fill DEPLOYER_PRIVATE_KEY
    with a random private key in the .env file (then used on hardhat.config.ts)
    You can run the `yarn account` command to check your balance in every network.
  */
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("FoodNFT", {
    from: deployer,
    log: true,
    autoMine: true,
  });

  await deploy("ERC6551Registry", {
    from: deployer,
    log: true,
    autoMine: true,
  });

  await deploy("ERC6551Account", {
    from: deployer,
    log: true,
    autoMine: true,
  });

  // await deploy("Ingredient", {
  //   from: deployer,
  //   log: true,
  //   autoMine: true,
  // });

  const registryContract = await hre.ethers.getContract("ERC6551Registry", deployer);

  await deploy("BreadToken", {
    from: deployer,
    log: true,
    autoMine: true,
  });
  const BreadContract = await hre.ethers.getContract("BreadToken", deployer);

  await deploy("MeatToken", {
    from: deployer,
    log: true,
    autoMine: true,
  });
  const MeatContract = await hre.ethers.getContract("MeatToken", deployer);

  await deploy("LettuceToken", {
    from: deployer,
    log: true,
    autoMine: true,
  });
  const LettuceContract = await hre.ethers.getContract("LettuceToken", deployer);

  await deploy("CoinToken", {
    from: deployer,
    log: true,
    autoMine: true,
  });
  const CoinContract = await hre.ethers.getContract("CoinToken", deployer);

  await deploy("FoodScramble", {
    from: deployer,
    args: [
      deployer,
      registryContract.address,
      BreadContract.address,
      MeatContract.address,
      LettuceContract.address,
      CoinContract.address,
    ],
    log: true,
    autoMine: true,
  });
};

export default deployYourContract;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployYourContract.tags = ["FoodNFT", "ERC6551Registry"];
