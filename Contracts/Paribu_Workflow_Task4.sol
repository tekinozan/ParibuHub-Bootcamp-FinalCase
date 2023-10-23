function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

//Bu kodda, balances güncellemeleri ve Transfer olayı önce yapılıyor, bu nedenle başka bir sözleşme veya hesap tarafından çağrılabilir.
//İşlemleri sıralamak için balances güncellemelerini önce yapmak yerine, msg.senderın bakiyesini güncellemeden önce diğer işlemleri gerçekleştirmeli.

//Token transferlerinde ve bakiye güncellemelerinde SafeMath gibi kütüphaneleri kullanarak integer taşmalarını önlemek önemlidir. 
//Bu, işlemler sırasında integer taşmalarını önleyerek güvenliği artırır.
