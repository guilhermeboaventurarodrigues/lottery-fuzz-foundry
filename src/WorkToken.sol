//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract WorkToken is ERC20{
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(uint256 supply) ERC20("WorkToken", "WTK"){
        _mint(msg.sender, supply);
    }

    function totalSupply() public view override returns(uint256){
         return _totalSupply;
    }

    function decimals() public pure override returns(uint8){
        return 18;
    }

    function balanceOf(address wallet) public override view returns(uint256){
        return _balances[wallet];
    }

    function transfer(address recipient, uint256 amount) public override returns(bool){
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns(bool){
        require(_balances[msg.sender] >= amount);
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exeeds balance");
        unchecked{
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal override{
        _totalSupply +=amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }


}