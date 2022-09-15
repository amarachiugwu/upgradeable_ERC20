
//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Proxy is ERC20, Ownable {
    
    string public _name;
    string public _symbol;
    constructor() ERC20("MyToken", "MY") {
    }


    fallback () external payable {
        assembly {
            let ptr := mload(0x40)

            // (1) copy incoming call data
            calldatacopy(ptr, 0, calldatasize)

            // (2) forward call to logic contract
            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
            let size := returndatasize

            // (3) retrieve return data
            returndatacopy(ptr, 0, size)

            // (4) forward return data back to caller
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
            }
    }
}