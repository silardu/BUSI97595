// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ; // solidity versions

contract SimpleStorage {
    // Define two state variables to store the favorite module and lecture
    string private favModule;
    string private favTA;

    // Function to set the favorite module and lecture
    function setFavorites(string memory _favModule, string memory _favTA) public {
        favModule = _favModule;
        favTA = _favTA;
    }

    // Function to get the favorite module and lecture
    function getFavorites() public view returns (string memory, string memory) {
        return (favModule, favTA);
    }
}