# :moneybag: Contrato de loteria, aonde você compra um ticket e participa do sorteio, testes em fuzz com o Foundry.

## :briefcase: Regras de negócio:
<p><b>O valor do ticket é 500 tokens, o sorteio acontece de forma manual, quando o sorteio é feito, o ganhador fica com o valor de todos os tickets comprados.</b></p>

## :toolbox: Tecnologias utilizadas:
-  Foundry
-  Solidity

## :heavy_check_mark: Testes positivos: 14
<p>:slot_machine: Lottery</p>

- testBuyTicket()
- testGiftWinner()
- testGetValueGift()

<p>:dollar: Token</p>

- testTokenName()
- testTokenSymbols()
- testTokenDecimals()
- testTotalSupply()

<p>:pencil2: Fuzz Tests</p>

- testFuzzBalanceOf(addres wallet)
- testFuzzTransfer(address recipient, uint256 amount)
- testFuzzTransferFrom(address from, address to, uint256 amount)
- testFuzzApprove(address spender, uint256 amount)
- testFuzzAllowance(address ownerToken, address spender)
- testFuzzIncreaseAllowance(address spender, uint256 amount)
- testFuzzDecreaseAllowance(address spender, uint256 amount)

## :bangbang: Testes negativos: 10
<p>:slot_machine: Lottery</p>

- testFailBuyTicketStatusCLOSED()
- testFailGiftWinnerStatusCLOSED()
- testFailGiftWinnerNotOwner()
- testFailGetValueGiftStatusCLOSED()

<p>:dollar: Token</p>

<p>:pencil2: Fuzz Tests</p>

- testFailFuzzTransferNotBalance(address recipient, uint256 amount)
- testFailFuzzApproveNotBalance(address spender, uint256 amount)
- testFailFuzzTransferFromNotBalanace(address from, address to, uint256 amount)
- testFailFuzzTransferFromNotApprove(address from, address to, uint256 amount)
- testFailFuzzDecreaseAllowanceZeroBalance(address spender, uint256 amount)
- testFailBuyTicketOtherValue(uint256 amount)
