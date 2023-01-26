// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.16;

import "solmate/src/tokens/ERC721.sol";
import "solmate/src/utils/LibString.sol";
import "solmate/src/auth/Owned.sol";
//import {ERC721} from "solmate/src/aut";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

//is Owned(msg.sender)

contract PfpNft is ERC721 , Owned  {
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public constant MINT_PRICE = 1 ether;
    string public baseURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory base, 
        address   owner 
    ) ERC721(name, symbol)  Owned(owner) {
        baseURI = base;
    }

    function mintToPay(address recipient) external payable returns (uint256) {
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }
        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function mint(address recipient) external onlyOwner returns (uint256) {
        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, LibString.toString(tokenId)))
                : "";
    }

    function withdrawPayments(address payable payee) external {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }
}
