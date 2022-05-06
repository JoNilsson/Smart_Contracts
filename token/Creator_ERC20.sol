pragma solidity ^0.8.10;

/**
 * @title Creator ERC20 Token
 * @author JoNilsson
 * @date 05/06/2020
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they may later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
 
contract ERC20Token {
  // Public variables of the token
  string public name;
  string public symbol;
  uint8 public decimals = 18;
  // 18 decimals is the strongly suggested default, avoid changing it
  uint256 public totalSupply;

  // This creates an array with all balances
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  // This generates a public event on the blockchain that will notify clients
  event Transfer(address indexed from, address indexed to, uint256 value);

  // This notifies clients about an approval event
  event Approval(address indexed tokenOwner, address indexed spender, uint256 value);

  // Constructor that gives msg.sender all of existing tokens
  constructor(
    uint256 initialSupply,
    string tokenName,
    string tokenSymbol
  ) public {
    totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
    balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
    name = tokenName;                                   // Set the name for display purposes
    symbol = tokenSymbol;                                // Set the symbol for display purposes
  }

  /**
   * @dev Converts a specified amount of tokens to the owner in ether.
   * @param _tokenAmount The amount of tokens to be converted into ether.
   * @return Returns the amount of wei converted from the specified amount of tokens.
   */
  function tokenToEther(uint256 _tokenAmount) public view returns (uint256) {
    require(_tokenAmount <= balanceOf[msg.sender]);   // Check if the sender has enough of the token to convert
    return _tokenAmount * 0.000000000000000001;      // Convert the specified token amount into ether
  }

  /**
   * @dev Converts the specified amount of ether to tokens.
   * @param _etherAmount The amount of ether to be converted into tokens.
   * @return Returns the amount of tokens that were created from the specified amount of ether.
   */
  function etherToToken(uint256 _etherAmount) public view returns (uint256) {
    require(_etherAmount <= msg.value);              // Check if the sender has enough ether to convert
    return _etherAmount * 1000000000000000000;        // Convert the specified ether amount into tokens
  }

  /**
   * @dev Transfer token for a specified address
   * @param _to The address to transfer to.
   * @param _value The amount to be transferred.
   */
  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[msg.sender]);        // Check if the sender has enough of the token to transfer
    require(isContract(_to) == false);                // Check if the recipient is a contract address
    require(_to != address(0));                       // Check if the recipient is not the zero address

    // Notify anyone listening that this transfer took place
    emit Transfer(msg.sender, _to, _value);

    // Update the sender's balance
    balanceOf[msg.sender] -= _value;
    // Update the recipient's balance
    balanceOf[_to] += _value;

    return true;
  }

  /**
   * @dev Approves another address to spend a specified amount of tokens on behalf of msg.sender.
   * @param _spender The address of the account able to transfer the tokens.
   * @param _value The amount of tokens to be approved for transfer.
   */
  function approve(address _spender, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[msg.sender]);        // Check if the sender has enough of the token to approve
    require(isContract(_spender) == false);          // Check if the spender is a contract address
    require(_spender != address(0));                  // Check if the spender is not the zero address

    // Notify anyone listening that this approval took place
    emit Approval(msg.sender, _spender, _value);

    allowance[msg.sender][_spender] = _value;
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _tokenOwner The address of the account owning tokens.
   * @param _spender The address of the account able to transfer the tokens.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _tokenOwner, address _spender) public view returns (uint256 remaining) {
    return allowance[_tokenOwner][_spender];
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from The address to transfer from.
   * @param _to The address to transfer to.
   * @param _value The amount of tokens to be transferred.
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[_from]);           // Check if the from account has enough of the token to transfer
    require(_value <= allowance[_from][msg.sender]); // Check if the spender has been approved by the from account
    require(isContract(_to) == false);              // Check if the recipient is a contract address
    require(_to != address(0));                     // Check if the recipient is not the zero address

    // Notify anyone listening that this transfer took place
    emit Transfer(_from, _to, _value);

    // Update the from account's balance
    balanceOf[_from] -= _value;
    // Update the spender's allowance
    allowance[_from][msg.sender] -= _value;
    // Update the to account's balance
    balanceOf[_to] += _value;

    return true;
  }
}
