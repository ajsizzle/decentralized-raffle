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
    address payable[] public s_players;

    event RaffleEnter(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
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

    // Be true after some time interval
    // 2. The lottery to be open
    // 3. The contract has ETH
    // 4. Keepers has LINK
    function checkUpkeep() {

    }
}
