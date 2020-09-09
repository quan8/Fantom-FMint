pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "./FMintDataStore.sol";

// FantomCollateralStorage<abstract> implements a collateral storage used
// by the Fantom DeFi contract to track collateral accounts
// balances and value.
contract FantomCollateralStorage is FMintDataStore {
    
    // collateralTotal returns the total value of all the collateral tokens
    // registered inside the storage.
    function collateralTotal() public view returns (uint256 value) {
        return total();
    }

    // collateralValueOf returns the current collateral balance of the specified
    // account.
    function collateralValueOf(address _account) public view returns (uint256 value) {
        return valueOf(_account);
    }

    // -------------------------------------------------------------
    // Collateral state update functions
    // -------------------------------------------------------------

    // collateralAdd adds specified amount of tokens to given account
    // collateral and updates the total supply references.
    function collateralAdd(address _account, address _token, uint256 _amount) public {
        add(_account, _token, _amount);
    }

    // collateralSub removes specified amount of tokens from given account
    // collateral and updates the total supply references.
    function collateralSub(address _account, address _token, uint256 _amount) public {
        sub(_account, _token, _amount);
    }

    // -------------------------------------------------------------
    // Collateral related utility functions
    // -------------------------------------------------------------

    // collateralEnrollToken ensures the specified token is in the list
    // of collateral tokens registered with the protocol.
    function collateralEnrollToken(address _token) internal {
        enrollToken(_token);
    }

    // collateralTokensCount returns the number of tokens enrolled
    // to the collateral list.
    function collateralTokensCount() public view returns (uint256) {
        return tokensCount();
    }
}