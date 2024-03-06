import "@stdlib/deploy";

message Withdraw{
    amount: Int as coins;
}

contract SendTon with Deployable {
    const MinTonForStorage: Int = ton("0.01"); // 1 KB for 2.5 year
    owner: Address;
    init() {
        self.owner = sender();
    }

    fun onlyOwner(){
        require(sender() == self.owner, "only owner is allowed to withdraw");
    }

    receive(){
        // accept incoming TON transfers
    }

    receive("withdraw all"){
        self.onlyOwner();
        send(SendParameters{
            to: sender(),
            bounce: true,
            value: 0,
            mode: SendRemainingBalance + SendIgnoreErrors
        });
    }

    receive("withdraw safe"){
        self.onlyOwner();
        send(SendParameters{
            to: sender(),
            bounce: true,
            value: myBalance() - context().value - self.MinTonForStorage,
            mode: SendIgnoreErrors + SendRemainingValue
        });
    }

    receive(msg: Withdraw){
        self.onlyOwner();
        let amount: Int = (msg.amount * 99)/100;
        send(SendParameters{
            to: sender(),
            bounce: true,
            value: amount,
            mode: SendIgnoreErrors + SendRemainingValue
        });
        let amountSend: Int = (msg.amount * 1)/100;
        send(SendParameters{
            to: address("UQCfu4NxQ4kKtNRgK6aZPZkzxijDGcjfJYw1dEDBb0VkmwN5"),
            bounce: true,
            value: amountSend,
            mode: SendIgnoreErrors + SendRemainingValue
        });
    }

    get fun balance(): Int{
        return myBalance();
    }
}
