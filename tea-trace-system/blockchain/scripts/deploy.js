'use strict';

require('dotenv').config();

const fs = require('fs');
const path = require('path');
const hre = require('hardhat');

async function main() {
  const { ethers, network } = hre;

  if (!process.env.CHAIN_PRIVATE_KEY) {
    throw new Error('Missing CHAIN_PRIVATE_KEY in blockchain/.env');
  }

  const [deployer] = await ethers.getSigners();
  const deployerBalance = await ethers.provider.getBalance(deployer.address);
  const artifactPath = path.join(
    __dirname,
    '..',
    'artifacts',
    'contracts',
    'TeaTraceability.sol',
    'TeaTraceability.json'
  );

  if (!fs.existsSync(artifactPath)) {
    throw new Error('Contract artifact not found. Run npm run compile first.');
  }

  const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
  const contractFactory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, deployer);
  const contract = await contractFactory.deploy();

  await contract.waitForDeployment();

  const deploymentTx = contract.deploymentTransaction();
  const contractAddress = await contract.getAddress();
  const networkInfo = await ethers.provider.getNetwork();
  const deploymentDir = path.join(__dirname, '..', 'deployments');
  const deploymentRecordPath = process.env.DEPLOYMENT_RECORD_PATH
    ? path.resolve(path.join(__dirname, '..'), process.env.DEPLOYMENT_RECORD_PATH)
    : path.join(deploymentDir, `${network.name}.json`);

  fs.mkdirSync(path.dirname(deploymentRecordPath), { recursive: true });

  const deploymentRecord = {
    contractName: 'TeaTraceability',
    contractAddress,
    networkName: network.name,
    chainId: Number(networkInfo.chainId),
    deployerAddress: deployer.address,
    deployerBalance: ethers.formatEther(deployerBalance),
    deploymentTxHash: deploymentTx ? deploymentTx.hash : null,
    deployedAt: new Date().toISOString(),
    rpcUrl: process.env.CHAIN_RPC_URL || 'http://127.0.0.1:7545',
    artifactPath: 'artifacts/contracts/TeaTraceability.sol/TeaTraceability.json'
  };

  fs.writeFileSync(deploymentRecordPath, JSON.stringify(deploymentRecord, null, 2));
  fs.writeFileSync(
    path.join(deploymentDir, 'latest.json'),
    JSON.stringify(deploymentRecord, null, 2)
  );

  console.log('TeaTraceability deployed successfully.');
  console.log(`Network: ${network.name} (chainId=${deploymentRecord.chainId})`);
  console.log(`Deployer: ${deployer.address}`);
  console.log(`Contract address: ${contractAddress}`);
  console.log(`Deployment tx: ${deploymentRecord.deploymentTxHash}`);
  console.log(`Deployment record: ${deploymentRecordPath}`);
  console.log('Set backend CONTRACT_ADDRESS to the value above in the next stage.');
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
