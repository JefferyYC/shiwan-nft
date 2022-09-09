// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("Shi Wan Collection", "ShiWan") {
    console.log("This is my NFT contract. Woah!");
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    require (newItemId < 50, "All nft has been minted");

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "Shi Wan", "description": "A Legendary Cat", "image": "https://bafkreihsbb6dxjksry6jajiaxspnm4ljwhovvoji6ea4xk2d7tartiezse.ipfs.nftstorage.link/"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // We'll be setting the tokenURI later!
    _setTokenURI(newItemId, finalTokenUri);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
  }

  function getTotalNFTsMintedSoFar() view public returns(uint256) {
      return _tokenIds.current();
  }
}