pragma solidity ^0.4.23;

// Base class to define admin related modifier and methods
contract BaseAdmin {
  bool public isPaused = false;
  address public addrAdmin;

  constructor() public {
    addrAdmin = msg.sender;
  }

  modifier onlyAdmin() {
    require(msg.sender == addrAdmin);
    _;
  }

  function setAdmin(address _newAdmin) external onlyAdmin {
    require(_newAdmin != address(0));
    addrAdmin = _newAdmin;
  }

  function setPause(bool _pause) external onlyAdmin {
    isPaused = _pause;
  }
}
