pragma solidity ^0.5.16; // #####  SPDX-License-Identifier: None
contract auth {
    address public _owner;
    mapping (address => bool) public _gov;
    mapping (address => bool) public _whiteList;
    mapping (address => bool) public _adminList;
    mapping (address => bool) public _blackList;
    constructor() public{ 
        _owner = msg.sender; 
    }
        function isContract(address account) public view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
    
    function _msgSender() public view returns (address) {
        return msg.sender;
    }
    
    function _msgData() public pure returns (bytes memory) {
        return msg.data;
    }    
    function isOwner(address account) public view returns (bool) {
        return account == _owner;
    }
    
    function isGovern(address account) public view returns (bool) {
        return _gov[account];
    }
        
    function isAdmin(address account) public view returns (bool) {
        return _adminList[account];
    }
    
    
    function isAuth(address account) public view returns (bool) {
        return _whiteList[account];
    }

    function isBanned(address account) public view returns (bool) {
        return _blackList[account];
    }
    
    
    modifier onlyOwner() { require(isOwner(_msgSender())); _;   }
    
    
    modifier govern() {    require(isOwner(_msgSender()) || isGovern(_msgSender())    ); _;        }
        
    modifier admin() {    require(isOwner(_msgSender()) || isAdmin(_msgSender())    ); _;        }

    modifier _auth() {    require(_whiteList[_msgSender()] == true); _;  }
    modifier _banCheck() { require(_blackList[_msgSender()] == false); _; }
    
        
    function makeGov(address adr) public onlyOwner {
        _gov[adr] = true;
    }
    function takeAGov(address adr) public onlyOwner {
        _gov[adr] = false;
    }
    
        
    function makeAdmin(address adr) public onlyOwner {
        _adminList[adr] = true;
    }
    function takeAdmin(address adr) public onlyOwner {
        _adminList[adr] = false;
    }
    
        
    function whiteList(address adr) public admin {
        _whiteList[adr] = true;
    }
    function unwhiteList(address adr) public admin {
        _whiteList[adr] = false;
    }
    
    
   function blackList(address adr) public admin {
        _blackList[adr] = true;
    }
    function unBlackList(address adr) public admin {
        _blackList[adr] = false;
    }
    

    function transferOwnership(address payable adr) public onlyOwner {
        _owner = adr;
    }
}
