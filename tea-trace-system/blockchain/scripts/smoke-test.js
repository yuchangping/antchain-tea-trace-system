'use strict';

require('dotenv').config();

const fs = require('fs');
const path = require('path');
const { ethers } = require('ethers');

async function main() {
  const projectRoot = path.join(__dirname, '..');
  const artifactPath = path.join(
    projectRoot,
    'artifacts',
    'contracts',
    'TeaTraceability.sol',
    'TeaTraceability.json'
  );
  const deploymentPath = path.join(projectRoot, 'deployments', 'latest.json');

  if (!fs.existsSync(artifactPath)) {
    throw new Error('Artifact not found. Run npm run compile first.');
  }

  if (!fs.existsSync(deploymentPath)) {
    throw new Error('Deployment record not found. Run npm run deploy first.');
  }

  if (!process.env.CHAIN_PRIVATE_KEY) {
    throw new Error('Missing CHAIN_PRIVATE_KEY in blockchain/.env');
  }

  const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
  const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
  const provider = new ethers.JsonRpcProvider(process.env.CHAIN_RPC_URL || 'http://127.0.0.1:7545');
  const wallet = new ethers.Wallet(process.env.CHAIN_PRIVATE_KEY, provider);
  const contract = new ethers.Contract(deployment.contractAddress, artifact.abi, wallet);
  const baseNonce = await provider.getTransactionCount(wallet.address, 'pending');

  const suffix = Date.now();
  const batchNo = `TEA-STAGE3-${suffix}`;
  const batchHash = ethers.keccak256(ethers.toUtf8Bytes(`${batchNo}|West Lake Longjing|Green Tea`));
  const operateTime = Math.floor(Date.now() / 1000);
  const dataHash = ethers.keccak256(
    ethers.toUtf8Bytes(`${batchNo}|harvest|Tea Producer|${operateTime}`)
  );

  const createBatchTx = await contract.createBatch(batchNo, batchHash, {
    nonce: baseNonce
  });
  await createBatchTx.wait();

  const addTraceTx = await contract.addTraceRecord(
    batchNo,
    'harvest',
    dataHash,
    'Tea Producer',
    operateTime,
    {
      nonce: baseNonce + 1
    }
  );
  await addTraceTx.wait();

  const traceCount = await contract.getTraceCount(batchNo);
  const traceRecord = await contract.getTraceRecord(batchNo, 0);

  console.log('Smoke test passed.');
  console.log(`BatchNo: ${batchNo}`);
  console.log(`createBatch tx: ${createBatchTx.hash}`);
  console.log(`addTraceRecord tx: ${addTraceTx.hash}`);
  console.log(`Trace count: ${traceCount.toString()}`);
  console.log(
    `Trace record: ${traceRecord[0]} | ${traceRecord[1]} | ${traceRecord[2]} | ${traceRecord[3].toString()}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
