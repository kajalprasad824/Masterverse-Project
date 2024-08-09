const{ethers,upgrades} = require("hardhat");

async function main() {
    const gas = (await ethers.provider.getFeeData()).gasPrice;
    const DIDContract = await ethers.getContractFactory("MasterVerseDID");
    console.log("Deploying Master Verse DID Project .........");
    
    const DIDcontract = await upgrades.deployProxy(DIDContract,["0x4b6428460Dc6D016f8dcD8DF2612109539DC1562"], {
        gasPrice: gas,
        initializer: "initialize",
    })

    await DIDcontract.waitForDeployment();
    console.log("MasterVerse DID Project is deployed to : ",await DIDcontract.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

//npx hardhat run --network sepolia ignition/modules/MasterVerseDID.js
//npx hardhat verify --contract "contracts/MasterVerseDID.sol:MasterVerseDID" conntract address --network sepolia

//0xF7D98550a97D3C4D2D64e17f82868305B0CE03dE - transparent
//0x204Ff61608dF70345d2c177bce54BB1207F884BB - proxy admin
