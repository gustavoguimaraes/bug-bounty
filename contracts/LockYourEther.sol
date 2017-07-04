pragma solidity ^0.4.11;

import './zeppelin/SafeMath.sol';

import { Target } from "./zeppelin/Bounty.sol";

contract LockYourEther is Target {
  uint256 public totalLockedEtherInContract;
  address[] public lockedEtherAddressesList;

  struct User {
    uint256 releaseDate;
    uint256 value;
  }

  mapping (address => User) public balances;

  // params _releaseDate as timestamp
  function lockEtherUntil (uint256 _releaseDate) payable {
    require(_releaseDate > now);

    totalLockedEtherInContract = SafeMath.add(totalLockedEtherInContract, msg.value);
    balances[msg.sender].value = msg.value;
    balances[msg.sender].releaseDate = _releaseDate;
    lockedEtherAddressesList.push(msg.sender);
  }

  function withdraw () {
    require(now > balances[msg.sender].releaseDate && balances[msg.sender].value > 0);

    uint256 payout = balances[msg.sender].value;
    uint256 totalLockedEtherInContract = SafeMath.sub(totalLockedEtherInContract, payout);

    balances[msg.sender].value = 0;
    balances[msg.sender].releaseDate = 0;
    msg.sender.transfer(payout);
  }

  function checkInvariant() returns(bool) {
    uint256 totalAmountOfLockedEtherInBalances;

    for (uint256 i = 0; i < lockedEtherAddressesList.length; i++) {
      address balanceAddress = lockedEtherAddressesList[i];

      totalAmountOfLockedEtherInBalances = SafeMath.add(balances[balanceAddress].value, totalAmountOfLockedEtherInBalances);
    }

    return totalLockedEtherInContract == totalAmountOfLockedEtherInBalances;
  }
}
