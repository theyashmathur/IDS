// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Marketplace {
    address public owner;

    struct listForSell{
        address ownerOfNft;
        bool isListed;
        uint amount;
    }

    mapping(uint => listForSell) _listForSell;

    IERC20 token;
    IERC721 nft;
    
    constructor(address _tokenContractAddress, address _nftContractAddress){
       owner = msg.sender;
       token = IERC20(_tokenContractAddress);
       nft = IERC721(_nftContractAddress);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    function setOnSell(uint tokenID, uint amount) public onlyOwner{
        require(_listForSell[tokenID].isListed != true, "Token already on sell");
        _listForSell[tokenID].isListed = true;
        _listForSell[tokenID].amount = amount;

    }  

    function isListedForSell(uint tokenID) public view returns(bool, uint256){
       return (_listForSell[tokenID].isListed,  _listForSell[tokenID].amount);
      }
      
    function purchaseFromToken(uint256 tokenID, uint256 quantity) external returns(bool) {

        //Check If the token is not listed for sell yet
        require(_listForSell[tokenID].isListed == true, "Token is Not Listed For Sell");

        //Getting the address of buyer 
        address buyer = msg.sender; 

        //Gettting the NFT balance of seller 
        uint balanceOfNFT = nft.balanceOf(address(this));

        //Check NFT balance should not exceed the purchase quantity
        require(balanceOfNFT >= quantity, "Not Enough Tokens to Purchase, try Reducing the Quantity");
    
        //Gettting the token balance of buyer 
        uint balanceOfToken = token.balanceOf(msg.sender);

        // Getting the Amount of single NFT in token
        uint singleNFTamount =  _listForSell[tokenID].amount;
        
        //Getting the total token amount which user needs to spend in order to buy NFT
        uint totalAmountToken = quantity * singleNFTamount;

        //Checking if the token balance is below the purchase amount 
        require(balanceOfToken>= totalAmountToken, "Not Enough Tokens To Make This Transaction, Try Reducing Your Quantity");
        
        //Transferring tokens to the nft seller
        token.transferFrom(msg.sender, owner, totalAmountToken);

        // Transfering NFT to Buyer's address 
        nft.safeTransferFrom(owner, buyer, tokenID);

        return true;
    }

    function removeFromSell(uint tokenId) public onlyOwner{
        //Require that nft is on sale
        require(_listForSell[tokenId].isListed == true, "Token is not on sale!");

        _listForSell[tokenId].isListed = false;
        _listForSell[tokenId].amount = 0;
    }
}
