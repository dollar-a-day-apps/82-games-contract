pragma solidity ^0.4.23;

import "./BaseAdmin.sol";
import "./SafeMath.sol";

// Define the interface for the token contract on its methods
// that we would call from this contract
interface IToken82 {
  function balanceOf(address _owner) external view returns (uint256);
  function mint(address _to, uint256 _value) external returns (bool);
  function burn(address _from, uint256 _value) external returns (bool);
}

// The logic contract for handling game logic, including managing user predictions
contract Game82 is BaseAdmin {
  using SafeMath for uint256;

  struct PredictInfo {
    uint160 player;             // uint representation of the player address
    uint32  gameId;            // >= 1
    uint16  points;             // 0~255
    uint16  rebounds;           // 0~255
    uint16  assists;            // 0~255
  }

  event BuyVoucher(address player, uint256 amount, uint256 trxAmount);
  event Predict(uint256 logId, address player, uint32 gameId, uint16 points, uint16 rebounds, uint16 assists);

  address public addrFinance;                 // the address to hold the funds from player purchases
  uint256 public voucherPrice = 100000000;    // the rate/price of 1 voucher against 'sun'

  PredictInfo[] predictArray;
  mapping (address => uint256[]) playerToPredictIdMap;
  IToken82 tokenContract;

  constructor() public {
    addrAdmin = msg.sender;
    addrFinance = msg.sender;
    predictArray.length += 1;
  }

  // Call this to change the designated funds keeper address
  // Can only be called by the current finance address or admin
  function setFinanceAddress(address _addr) external {
    require(msg.sender == addrFinance || msg.sender == addrAdmin);
    addrFinance = _addr;
  }

  // Call this to change the voucher price/rate
  // Admin-only
  function setVoucherPrice(uint256 _price) external onlyAdmin {
    require(_price >= 100000 && _price <= 10000000);
    voucherPrice = _price;
  }

  // Call this to change the token contract
  // Admin-only
  function setTokenContract(address _addrToken) external onlyAdmin {
    require(_addrToken != address(0));
    tokenContract = IToken82(_addrToken);
  }

  // Call this to proceed with actual voucher purchases
  function buyVoucher(uint256 _amount) external payable {
    // Set to only allow a max of 1000 vouchers at once
    // Then check if the user has enough TRX for the amount due
    require(_amount >= 1 && _amount <= 1000);
    uint256 trxAmount = _amount.mul(voucherPrice);
    require(msg.value == trxAmount);

    // Notify the token contract to mint the vouchers
    // Then redirect the TRX paid by user to the finance address
    require(tokenContract.mint(msg.sender, _amount));
    addrFinance.transfer(trxAmount);

    // Log the event
    emit BuyVoucher(msg.sender, _amount, trxAmount);
  }

  // Handle the actual prediction validation and recording
  function submitPrediction(uint16 _value, uint32 _gameId, uint16 _points, uint16 _rebounds, uint16 _assists) external {
    // Check if the user has enough voucher and validate the prediction parameters
    uint256 voucherCount = tokenContract.balanceOf(msg.sender);
    require(voucherCount >= _value);
    require(_value == 1);
    require(_gameId >= 1);
    require(_points <= 100 && _rebounds <= 100 && _assists <= 100);

    // Burn the vouchers consumed/used, currently it has to be exactly 1
    require(tokenContract.burn(msg.sender, _value));

    uint256 logId = predictArray.length;
    PredictInfo memory pi = PredictInfo(uint160(msg.sender), _gameId, _points, _rebounds, _assists);
    predictArray.push(pi);

    // Record the prediction to our local storage
    // As well as log the event
    uint256[] storage idArray = playerToPredictIdMap[msg.sender];
    idArray.push(logId);

    emit Predict(logId, msg.sender, _gameId, _points, _rebounds, _assists);
  }

  // On emergency, call this to withdraw all remaining TRX from this address
  function withdrawTRX(address _to, uint256 _amount) external onlyAdmin {
    uint256 totalTRX = address(this).balance;
    require(_to != address(0) && _amount <= totalTRX);
    _to.transfer(_amount);
  }
}
