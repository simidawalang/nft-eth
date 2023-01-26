import { ethers } from "hardhat";
import { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } from "../constants";

const deploy = async () => {
  const orisa = await ethers.getContractFactory("Orisa");

  const orisaContract = await orisa.deploy(
    METADATA_URL,
    WHITELIST_CONTRACT_ADDRESS
  );

  const deployedContract = await orisaContract.deployed();

  console.log("The Orisa contract address: ", deployedContract.address);
//   The Orisa contract address:  0xA7812F3460150653D15c76FF835b3Bb1Aa9D01Fd
};

deploy()
  .then(() => process.exit(0))
  .catch((e) => {
    console.debug(e);
    process.exit(1);
  });
