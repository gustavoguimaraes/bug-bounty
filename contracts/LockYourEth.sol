pragma solidity ^0.4.10;

import 'zeppelin/SafeMath.sol';

contract LockYourEther {

  uint totalLockedInContract;

  struct User {
    uint releaseDate;
    uint value;
  }

  mapping (address => User) public balances;

  /// @params _releaseDate as timestamp
  function lockEtherUntil (uint _releaseDate) payable {
    require(_releaseDate > now);

    totalLockedInContract = SafeMath.add(totalLockedInContract, msg.value);
    balances[msg.sender].value = msg.value;
    balances[msg.sender].releaseDate = _releaseDate;
  }

  function withdraw () {
    require(now > balances[msg.sender].releaseDate && balances[msg.sender].value > 0);

    uint payout = balances[msg.sender].value;
    uint totalLockedInContract = SafeMath.sub(totalLockedInContract, payout);

    balances[msg.sender].value = 0;
    balances[msg.sender].releaseDate = 0;
    msg.sender.transfer(payout);
  }
}
