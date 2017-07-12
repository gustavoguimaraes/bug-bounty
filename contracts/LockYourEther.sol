pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import { Target } from "zeppelin-solidity/contracts/Bounty.sol";

contract LockYourEther is Target {
  uint256 public totalLockedWei;
  address[] public lockedAddresses;

  struct User {
    uint256 releaseDate;
    uint256 value;
  }

  mapping (address => User) public balances;

  // params _releaseDate as timestamp
  function lockFundsUntil (uint256 _releaseDate) payable {
    require(_releaseDate > now);

    totalLockedWei = SafeMath.add(totalLockedWei, msg.value);
    balances[msg.sender].value = msg.value;
    balances[msg.sender].releaseDate = _releaseDate;
    lockedAddresses.push(msg.sender);
  }

  function withdraw () {
    require(now > balances[msg.sender].releaseDate && balances[msg.sender].value > 0);

    uint256 payout = balances[msg.sender].value;
    uint256 totalLockedWei = SafeMath.sub(totalLockedWei, payout);

    balances[msg.sender].value = 0;
    balances[msg.sender].releaseDate = 0;
    msg.sender.transfer(payout);
  }

  function checkInvariant() returns(bool) {
    uint256 totalAmountLockedInBalances;

    for (uint256 i = 0; i < lockedAddresses.length; i++) {
      address balanceAddress = lockedAddresses[i];

      totalAmountLockedInBalances = SafeMath.add(balances[balanceAddress].value, totalAmountLockedInBalances);
    }

    return totalLockedWei == totalAmountLockedInBalances;
  }
}
