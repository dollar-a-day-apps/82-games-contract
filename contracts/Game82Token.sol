pragma solidity ^0.4.23;

import "./SafeMath.sol";

// The token contract for direct handling of the voucher balances and other voucher related procedures
contract Game82Token {
  using SafeMath for uint256;

  address public owner;
  address private logicContractAddress;

  // Define TRC20 standard metadata for the vouchers (token)
  uint8 public decimals = 0;
  string public name = "82GameVoucher";
  string public symbol = "82GV";

  mapping (address => uint256) private _balances;
  mapping (address => mapping(address => uint256)) private _allowed;

  event Mint(address indexed _to, uint256 _value);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  constructor() public {
    owner = msg.sender;
  }

  // Call this to hand over ownership of the contract
  function transferOwnership(address _newOwner) external {
    require(msg.sender == owner);
    require(_newOwner != address(0) && _newOwner != owner);
    owner = _newOwner;
  }

  // Call this to change the address of the logic contract
  function setLogicContract(address _newLogic) external {
    require(msg.sender == owner);
    require(_newLogic != address(0) && _newLogic != logicContractAddress);
    logicContractAddress = _newLogic;
  }

  // Get users' voucher balance
  function balanceOf(address _owner) external view returns (uint256) {
    return _balances[_owner];
  }

  // Called by the logic contract upon successfull voucher purchases
  function mint(address _to, uint256 _value) external returns (bool) {
    require(msg.sender == logicContractAddress);
    require(_value > 0);
    require(_to != address(0));

    _balances[_to] = _balances[_to].add(_value);

    emit Mint(_to, _value);

    return true;
  }

  // Called by the logic contract to burn consumed/used vouchers
  function burn(address _from, uint256 _value) external returns (bool) {
    require(msg.sender == logicContractAddress);
    require(_value > 0);
    require(_from != address(0));

    _balances[_from] = 0;

    return true;
  }

  // Not currently used but it's here to comply with TRC20 standard
  function allowance(address _owner, address _spender) external view returns (uint256) {
    return _allowed[_owner][_spender];
  }

  // Not currently used but it's here to comply with TRC20 standard
  function transfer(address _to, uint256 _value) external returns (bool) {
    require(_value <= _balances[msg.sender] && _value > 0);
    require(_to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(_value);
    _balances[_to] = _balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  // Not currently used but it's here to comply with TRC20 standard
  function approve(address _spender, uint256 _value) public returns (bool) {
    require(_spender != address(0));

    _allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  // Not currently used but it's here to comply with TRC20 standard
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
    require(_to != address(0));
    require(_value <= _balances[_from] && _value > 0);
    require(_value <= _allowed[_from][msg.sender]);

    _balances[_from] = _balances[_from].sub(_value);
    _balances[_to] = _balances[_to].add(_value);
    _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);

    return true;
  }
}
