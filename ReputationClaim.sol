// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReputationClaim {
    address public owner;
    uint256 public rewardAmount;
    mapping(address => uint256) public lastClaimedWeek;
    mapping(bytes32 => bool) public usedCastHashes;

    event Claimed(address indexed user, bytes32 indexed castHash, uint256 week, uint256 amount);

    constructor(uint256 _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
    }

    function getCurrentWeek() public view returns (uint256) {
        return block.timestamp / 1 weeks;
    }

    function claim(bytes32 castHash) external {
        require(!usedCastHashes[castHash], "Cast already used");
        uint256 currentWeek = getCurrentWeek();
        require(lastClaimedWeek[msg.sender] < currentWeek, "Already claimed this week");

        lastClaimedWeek[msg.sender] = currentWeek;
        usedCastHashes[castHash] = true;

        // In production, reward logic would transfer tokens. We just emit event for now.
        emit Claimed(msg.sender, castHash, currentWeek, rewardAmount);
    }

    function setRewardAmount(uint256 _amount) external {
        require(msg.sender == owner, "Not owner");
        rewardAmount = _amount;
    }
}
