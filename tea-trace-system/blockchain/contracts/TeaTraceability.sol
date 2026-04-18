// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TeaTraceability {
    struct BatchInfo {
        bytes32 batchHash;
        uint256 createdAt;
        address creator;
        bool exists;
    }

    struct TraceRecord {
        string stageType;
        bytes32 dataHash;
        string operatorName;
        uint256 operateTime;
        uint256 createdAt;
        address creator;
    }

    mapping(string => BatchInfo) private batches;
    mapping(string => TraceRecord[]) private batchTraceRecords;

    event BatchCreated(
        string indexed batchNo,
        bytes32 indexed batchHash,
        uint256 createdAt,
        address indexed creator
    );

    event TraceRecordAdded(
        string indexed batchNo,
        bytes32 indexed dataHash,
        address indexed creator,
        string stageType,
        string operatorName,
        uint256 operateTime,
        uint256 traceIndex
    );

    function createBatch(string memory batchNo, bytes32 batchHash) external {
        _requireNonEmpty(batchNo, "batchNo");
        require(!batches[batchNo].exists, "Batch already exists");

        batches[batchNo] = BatchInfo({
            batchHash: batchHash,
            createdAt: block.timestamp,
            creator: msg.sender,
            exists: true
        });

        emit BatchCreated(batchNo, batchHash, block.timestamp, msg.sender);
    }

    function addTraceRecord(
        string memory batchNo,
        string memory stageType,
        bytes32 dataHash,
        string memory operatorName,
        uint256 operateTime
    ) external {
        require(batches[batchNo].exists, "Batch does not exist");
        _requireNonEmpty(stageType, "stageType");
        _requireNonEmpty(operatorName, "operatorName");
        require(_isValidStageType(stageType), "Invalid stageType");

        uint256 traceIndex = batchTraceRecords[batchNo].length;
        batchTraceRecords[batchNo].push(
            TraceRecord({
                stageType: stageType,
                dataHash: dataHash,
                operatorName: operatorName,
                operateTime: operateTime,
                createdAt: block.timestamp,
                creator: msg.sender
            })
        );

        emit TraceRecordAdded(
            batchNo,
            dataHash,
            msg.sender,
            stageType,
            operatorName,
            operateTime,
            traceIndex
        );
    }

    function getTraceCount(string memory batchNo) external view returns (uint256) {
        require(batches[batchNo].exists, "Batch does not exist");
        return batchTraceRecords[batchNo].length;
    }

    function getTraceRecord(
        string memory batchNo,
        uint256 index
    )
        external
        view
        returns (
            string memory stageType,
            bytes32 dataHash,
            string memory operatorName,
            uint256 operateTime,
            uint256 createdAt,
            address creator
        )
    {
        require(batches[batchNo].exists, "Batch does not exist");
        require(index < batchTraceRecords[batchNo].length, "Trace record index out of bounds");

        TraceRecord memory record = batchTraceRecords[batchNo][index];
        return (
            record.stageType,
            record.dataHash,
            record.operatorName,
            record.operateTime,
            record.createdAt,
            record.creator
        );
    }

    function getBatch(
        string memory batchNo
    )
        external
        view
        returns (
            bytes32 batchHash,
            uint256 createdAt,
            address creator,
            bool exists,
            uint256 traceCount
        )
    {
        BatchInfo memory batch = batches[batchNo];
        return (
            batch.batchHash,
            batch.createdAt,
            batch.creator,
            batch.exists,
            batchTraceRecords[batchNo].length
        );
    }

    function batchExists(string memory batchNo) external view returns (bool) {
        return batches[batchNo].exists;
    }

    function _requireNonEmpty(string memory value, string memory fieldName) private pure {
        require(bytes(value).length > 0, string.concat(fieldName, " cannot be empty"));
    }

    function _isValidStageType(string memory stageType) private pure returns (bool) {
        bytes32 stageHash = keccak256(bytes(stageType));

        return
            stageHash == keccak256(bytes("harvest")) ||
            stageHash == keccak256(bytes("process")) ||
            stageHash == keccak256(bytes("inspection")) ||
            stageHash == keccak256(bytes("package")) ||
            stageHash == keccak256(bytes("logistics")) ||
            stageHash == keccak256(bytes("sale"));
    }
}
