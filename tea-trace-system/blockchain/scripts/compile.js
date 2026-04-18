'use strict';

const fs = require('fs');
const path = require('path');
const solc = require('solc');

const projectRoot = path.join(__dirname, '..');
const contractRelativePath = path.join('contracts', 'TeaTraceability.sol');
const contractAbsolutePath = path.join(projectRoot, contractRelativePath);
const artifactDir = path.join(projectRoot, 'artifacts', 'contracts', 'TeaTraceability.sol');
const artifactPath = path.join(artifactDir, 'TeaTraceability.json');

function compileContract() {
  const source = fs.readFileSync(contractAbsolutePath, 'utf8');
  const input = {
    language: 'Solidity',
    sources: {
      [contractRelativePath]: {
        content: source
      }
    },
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      outputSelection: {
        '*': {
          '*': ['abi', 'evm.bytecode', 'evm.deployedBytecode']
        }
      }
    }
  };

  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  const diagnostics = output.errors || [];
  const fatalErrors = diagnostics.filter((item) => item.severity === 'error');

  diagnostics.forEach((item) => {
    const writer = item.severity === 'error' ? console.error : console.warn;
    writer(item.formattedMessage.trim());
  });

  if (fatalErrors.length > 0) {
    throw new Error(`Solidity compilation failed with ${fatalErrors.length} error(s).`);
  }

  const compiled = output.contracts[contractRelativePath].TeaTraceability;
  const artifact = {
    _format: 'hh-sol-artifact-1',
    contractName: 'TeaTraceability',
    sourceName: contractRelativePath,
    abi: compiled.abi,
    bytecode: `0x${compiled.evm.bytecode.object}`,
    deployedBytecode: `0x${compiled.evm.deployedBytecode.object}`,
    linkReferences: compiled.evm.bytecode.linkReferences || {},
    deployedLinkReferences: compiled.evm.deployedBytecode.linkReferences || {}
  };

  fs.mkdirSync(artifactDir, { recursive: true });
  fs.writeFileSync(artifactPath, JSON.stringify(artifact, null, 2));

  console.log(`Compiled TeaTraceability with solc ${solc.version()}`);
  console.log(`Artifact written to ${artifactPath}`);
}

compileContract();
