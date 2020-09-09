pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

// FMintDataStore implements a storage used
// by the Fantom DeFi contract to track accounts balances and value.
contract FMintDataStore {
    // define used libs
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for ERC20;

    // -------------------------------------------------------------
    // State variables
    // -------------------------------------------------------------

    // _balances tracks user => token => amount relationship
    mapping(address => mapping(address => uint256)) public _balances;

    // _totalBalances keeps track of the total balances
    // of all the tokens registered in the storage
    // mapping: token => amount
    mapping(address => uint256) public _totalBalances;

    // __tokens represents the list of all collateral tokens
    // registered with the collateral storage.
    address[] public _tokens;

    // -------------------------------------------------------------
    // Value related calculations
    // -------------------------------------------------------------

    // tokenValue (abstract) returns the value of the given amount of the token specified.
    function tokenValue(address _token, uint256 _amount) public view returns (uint256);

    // total() returns the total value of all the tokens
    // registered inside the storage.
    function total() public view returns (uint256 value) {
        // loop all registered tokens
        for (uint i = 0; i < _tokens.length; i++) {
            // advance the total value by the current balance token value
            value = value.add(tokenValue(_tokens[i], _totalBalances[_tokens[i]]));
        }

        // keep the value
        return value;
    }
    
    // balance() returns the current balance of the specified account of the specified token.
    function balance(address _account, address _token) public view returns (uint256 value) {
    	return _balances[_account][_token];
    }

    // valueOf() returns the current balance of the specified account.
    function valueOf(address _account) public view returns (uint256 value) {
        // loop all registered tokens
        for (uint i = 0; i < _tokens.length; i++) {
            // advance the value by the current balance tokens on the account token scanned
            if (0 < _balances[_account][_tokens[i]]) {
                value = value.add(tokenValue(_tokens[i], _balances[_account][_tokens[i]]));
            }
        }

        return value;
    }

    // -------------------------------------------------------------
    // State update functions
    // -------------------------------------------------------------

    // add() adds specified amount of tokens to given account
    // and updates the total supply references.
    function add(address _account, address _token, uint256 _amount) internal {
        // update the collateral balance of the account
        _balances[_account][_token] = _balances[_account][_token].add(_amount);

        // update the total balance
        _totalBalances[_token] = _totalBalances[_token].add(_amount);

        // make sure the token is registered
        enrollToken(_token);
    }

    // sub() removes specified amount of tokens from given account
    // and updates the total supply references.
    function sub(address _account, address _token, uint256 _amount) internal {
        // update the balance of the account
        _balances[_account][_token] = _balances[_account][_token].sub(_amount);

        // update the total balance
        _totalBalances[_token] = _totalBalances[_token].sub(_amount);
    }

    // -------------------------------------------------------------
    // Utility functions
    // -------------------------------------------------------------

    // enrollToken ensures the specified token is in the list
    // of tokens registered with the protocol.
    function enrollToken(address _token) internal {
        bool found = false;

        // loop the current list and try to find the token
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (_tokens[i] == _token) {
                found = true;
                break;
            }
        }

        // add the token to the list if not found
        if (!found) {
            _tokens.push(_token);
        }
    }

    // _tokensCount returns the number of tokens enrolled
    // to the list.
    function tokensCount() public view returns (uint256) {
        // return the current collateral array length
        return _tokens.length;
    }
}