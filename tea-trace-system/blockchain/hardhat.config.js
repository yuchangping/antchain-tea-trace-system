'use strict';

require('@nomicfoundation/hardhat-ethers');
require('dotenv').config();

const chainRpcUrl = process.env.CHAIN_RPC_URL || 'http://127.0.0.1:7545';
const chainId = Number(process.env.CHAIN_ID || 1337);
const rawPrivateKey = process.env.CHAIN_PRIVATE_KEY || '';
const normalizedPrivateKey = rawPrivateKey
  ? (rawPrivateKey.startsWith('0x') ? rawPrivateKey : `0x${rawPrivateKey}`)
  : '';

module.exports = {
  solidity: {
    version: '0.8.24',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    ganache: {
      url: chainRpcUrl,
      chainId,
      accounts: normalizedPrivateKey ? [normalizedPrivateKey] : []
    }
  }
};
