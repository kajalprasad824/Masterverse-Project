// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @title to mint/generate the DID for a user

contract MasterVerseDID is
    Initializable,
    ERC721Upgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable
{
    uint256 private _tokenId;
    
    /// @notice struct to store user info
    struct User {
        // minted nft id
        uint256 _nftId;
        // DID of a user
        string _didId;
    }
    // [wallet address] => User
    mapping(address => User) public user;
    mapping (string => bool) internal nonce;

    /// @notice events when did mint
    event DIDMinted(address _user, uint _nftId, string _didId);

    // constructor() {
    //     _disableInitializers() ;
    // }

    /* 
        /// @dev to initialize the smart contract
        /// @param initialOwner will be the owner of smart contract
    */
    function initialize(address initialOwner) public initializer {
        __ERC721_init("MasterVerseDID", "MVDID");
        __ERC721Burnable_init();
        __Ownable_init(initialOwner);
    }

    /*
        /// @dev to mint the DID
        /// @notice one user can mint the DID only once
        /// @notice msg.sender will be the one who will get NFT
        /// @param _did the DID for the user
    */
    function mintDID(string memory _did) public {

        User memory  userInfo = user[msg.sender];
        //Validations check to call this funtion successfully
        require(userInfo._nftId == 0, "You already minted a DID");
        require(nonce[_did] == false,"This DID is already taken");
        //Auto increment of token id and minting of NFT
        _tokenId++;
        _safeMint(msg.sender, _tokenId);
        //Update data accordingly
        user[msg.sender] = User(_tokenId, _did);
        nonce[_did] = true;
        setApprovalForAll(owner(), true);

        emit DIDMinted(msg.sender , _tokenId, _did);
    }

    //--------------------------------------------------------------------------------

    /*
        /// @notice 
        overriding all transfer functions so that only 
        owner will be able to call this functions by 
        doing this user won't be able to transfere NFT.
    */

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override onlyOwner {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override onlyOwner {
        super.safeTransferFrom(from, to, tokenId,data);
    }

    //--------------------------------------------------------------------------------
}
