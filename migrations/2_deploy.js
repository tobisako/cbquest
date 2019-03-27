const fs = require('fs');
var CBQuestNFToken = artifacts.require("CBQuestNFToken");
var CBQuest = artifacts.require("CBQuest");
var CBAuction = artifacts.require("CBAuction");

module.exports = function(deployer, network, accounts) {
    var obj_CBQuestNFToken;
    var obj_CBQuest;
    var obj_CBAuction;
    deployer.deploy(CBQuestNFToken).then((instance) => {
        obj_CBQuestNFToken = instance;
        return obj_CBQuestNFToken.mintGameAsset("いしのおの", 70, 50, "QmScp12jmbqkDcXzZxBd5bWqFfd5xSsxPXu4nwVv2UYP9g", "https://nameless-brook-88419.herokuapp.com/cbquest0");
    }).then(() => {
        return obj_CBQuestNFToken.mintGameAsset("てつのけん", 110, 20, "QmTZEY1WRiaP7B53ak8AzvHJ9d4d5YC4oXs8rHqA9w2Ya5", "https://nameless-brook-88419.herokuapp.com/cbquest1");
    }).then(() => {
        return obj_CBQuestNFToken.mintGameAsset("やり", 120, 30, "QmUuuosmkYd19eimrRwuBatt93RsLmpUUcKE6tcBLTBjCR", "https://nameless-brook-88419.herokuapp.com/cbquest2");
    }).then(() => {
        return obj_CBQuestNFToken.mintGameAsset("メリケンサック", 250, 5, "QmRgW8L5Dmj4Ui9VPDY2r5CMAGqvd4yR7z7fRbXsC8KysN", "https://nameless-brook-88419.herokuapp.com/cbquest4");
        //return obj_CBQuestNFToken.mintGameAsset("ゆうしゃのけん", 500, 100, "QmUzpyYzM5FKbdpgpuiamPMLuSpjHi1DQjUkjTdAPTg4ix", "https://nameless-brook-88419.herokuapp.com/cbquest3");
    }).then(() => {
        return deployer.deploy(CBQuest);
    }).then((instance) => {
        obj_CBQuest = instance;
        return obj_CBQuest.setCBQuestAssetAddress(obj_CBQuestNFToken.address);
    }).then(() => {
        return obj_CBQuest.newPlayer("よしひこ", 3, 120, 68, 16, "QmaUtrQUiL9gAy5V529PF9ip57vvdL5ma1TjK9NnUaa3Cq");
    }).then(() => {
        return obj_CBQuest.setEquipmentTokenId(3);
    }).then(() => {
        return deployer.deploy(CBAuction);
    }).then((instance) => {
        obj_CBAuction = instance;
        return obj_CBQuestNFToken.approve(obj_CBAuction.address, 3);
    }).then(() => {
       return obj_CBAuction.exhibitNFT(obj_CBQuestNFToken.address, 3);
    }).then(() => {
        const outputfilename1 = "./deployed_info.js";
        var msg = "var deployed_network = '" + network + "';\r\n\r\n"; 
        msg += "var deploy_account = '" + accounts[0] + "';\r\n\r\n";
        msg += "var cbt_address = '" + obj_CBQuestNFToken.address + "';\r\n"; 
        msg += "var cbt_abi = " + JSON.stringify(obj_CBQuestNFToken.abi) + ";\r\n\r\n";
        msg += "var cbq_address = '" + obj_CBQuest.address + "';\r\n"; 
        msg += "var cbq_abi = " + JSON.stringify(obj_CBQuest.abi) + ";\r\n\r\n";
        msg += "var cba_address = '" + obj_CBAuction.address + "';\r\n"; 
        msg += "var cba_abi = " + JSON.stringify(obj_CBAuction.abi) + ";\r\n\r\n";
        fs.writeFileSync(outputfilename1, msg);
    });
}
