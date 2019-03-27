const CBQuestNFToken = artifacts.require('CBQuestNFToken');

contract('CBQuestNFToken', function ([creator, ...accounts]) {
    const name = "CBQuestAssetToken";
    const symbol = "CBQA";

    it("check token name and tokenId.", async () => {
        const instance = await CBQuestNFToken.deployed();
        let tokenName = await instance.name();
        let tokenSymbol = await instance.symbol();

        assert.equal(tokenName, name, "Name isn't the same.");
        assert.equal(tokenSymbol, symbol, "Account isn't the same.");
    });

    it("mint test", async () => {
        const instance = await CBQuestNFToken.deployed();
        let totalSupply = await instance.totalSupply();
        let num = totalSupply.toNumber();
        assert.equal(num, 4, "total Supply is not same." + num + "desu.");
        await instance.mintGameAsset("HOGE", 123, 45, "HASH", "URI");

        let as = await instance.getGameAssetParam(1);
        assert.equal(as[0], "てつのけん", `itemName isn't the same. (${as[0]})`);
        assert.equal(as[1].toNumber(), 110, `attack isn't the same. (${as[1]})`);
        assert.equal(as[2].toNumber(), 20, `difence isn't the same. (${as[2]})`);
        assert.equal(as[3], "QmTZEY1WRiaP7B53ak8AzvHJ9d4d5YC4oXs8rHqA9w2Ya5", `ipfsHash isn't the same. (${as[3]})`);
    });
});
