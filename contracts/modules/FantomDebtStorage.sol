pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "./FMintDataStore.sol";

// FantomDebtStorage implements a debt storage used
// by the Fantom DeFi contract to track debt accounts balances and value.
contract FantomDebtStorage is FMintDataStore {
    
    // -------------------------------------------------------------
    // Debt value related calculations
    // -------------------------------------------------------------

    // debtTotal returns the total value of all the debt tokens
    // registered inside the storage.
    function debtTotal() public view returns (uint256 value) {
        return total();
    }

    // debtValueOf returns the current debt balance of the specified account.
    function debtValueOf(address _account) public view returns (uint256 value) {
        return valueOf(_account);
    }

    // -------------------------------------------------------------
    // Debt state update functions
    // -------------------------------------------------------------

    // debtAdd adds specified amount of tokens to given account
    // debt (e.g. borrow/mint) and updates the total supply references.
    function debtAdd(address _account, address _token, uint256 _amount) public {
        add(_account, _token, _amount);
    }

    // debtSub removes specified amount of tokens from given account
    // debt (e.g. repay) and updates the total supply references.
    function debtSub(address _account, address _token, uint256 _amount) public {
        sub(_account, _token, _amount);
    }

    // -------------------------------------------------------------
    // Debt related utility functions
    // -------------------------------------------------------------

    // debtEnrollToken ensures the specified token is in the list
    // of debt tokens registered with the protocol.
    function debtEnrollToken(address _token) internal {
        enrollToken(_token);
    }

    // debtTokensCount returns the number of tokens enrolled
    // to the debt list.
    function debtTokensCount() public view returns (uint256) {
        return tokensCount();
    }
}