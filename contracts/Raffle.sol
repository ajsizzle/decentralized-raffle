// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.7;

error Raffe__SendMoreToEnterRaffle();
error Raffle__RaffleNotOpen();

contract Raffle {
    enum RaffleState {
        Open,
        Calculating
    }

    RaffleState public s_raffleState;
    // initialize entrance fee one time in constructor.
    // will never change. immutable is gas efficient
    // prepend i_ to let devs know cheap variable.
    uint256 public immutable i_entranceFee;
    uint256 public immutable i_interval;
    address payable[] public s_players;
    uint256 public s_lastTimeStamp;

    event RaffleEnter(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough money sent!"); require statement is expensive
        if (msg.value < i_entranceFee) {
            revert Raffe__SendMoreToEnterRaffle();
        }
        // Open, Calculating a winner
        if (s_raffleState != RaffleState.Open) {
            revert Raffle__RaffleNotOpen();
        }
        // You can enter!
        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    }

    // 1 we want this done automatically
    // 2 we want a real random winner

    // 1. Be true after some time interval
    // 2. The lottery to be open
    // 3. The contract has ETH
    // 4. Keepers has LINK
    function checkUpkeep(
        bytes memory /* checkData */
    ) 
        public 
        view 
        returns (
            bool upkeepNeeded, 
            bytes memory /* performData */
        )
    {
        bool isOpen = RaffleState.Open == s_raffleState;
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval); // keep track of time
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (timePassed && hasBalance && isOpen);
        return (upkeepNeeded, "");
    }
}
