const CBQuest = artifacts.require('CBQuest');

contract('CBQuest', function ([creator, ...accounts]) {
    it("init player check", async () => {
        const instance = await CBQuest.deployed();

        let res = await instance.checkPlayerRegistered();
        assert.equal(res, true, "Player Regist Err.");

        let idx = await instance.getPlayerIndex();
        let as = await instance.players(idx);
        assert.equal(as[1], "よしひこ", `name isn't the same. (${as[1]})`);
    });
});
