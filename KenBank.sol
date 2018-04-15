pragma solidity ^0.4.16;

contract KenBank {
    
    mapping(address => uint256) accountBalance;
    uint256 feeAccountBalance;
    
    address public ownerAddress;
    string author = "D0349892";
    
    event depositEvent(uint256 time, address own, uint256 depositAmount);
    event withdrawEvent(uint256 time, address withdrawAddress, uint256 withdrawAmount);
    event withdrawFeeEvent(uint256 time, address withdrawAddress, uint256 withdrawAmount);
    
    function KenBank() public payable {
        ownerAddress = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }
    
    function deposit() public payable {
        accountBalance[msg.sender] += msg.value;
        feeAccountBalance += msg.value *1/10;
        emit depositEvent(now, msg.sender, msg.value);
    }
    
    function withdraw(uint256 withdrawAmount) public payable {
        require(withdrawAmount <= accountBalance[msg.sender]);
        accountBalance[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount*9/10);
        emit withdrawEvent(now, msg.sender, withdrawAmount);
    }
    
    function withdrawFee(uint256 withdrawAmount) public payable onlyOwner {
        require(withdrawAmount <= feeAccountBalance);
        feeAccountBalance -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit withdrawFeeEvent(now, msg.sender, withdrawAmount);
    }
    
    function getAccountBalance() public view returns(uint256) {
        return accountBalance[msg.sender];
    }
    
    function getFeeAccountBalance() public view onlyOwner returns(uint256) {
        return feeAccountBalance;
    }
    
    function getAuthors() public view returns(string) {
        return author;
    }
}