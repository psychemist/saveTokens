import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const tokenAddress = "0x802Cd92D3777E6865017A250B33DDD61F94c1f24";

const SaveERC20Module = buildModule("SaveERC20Module", (m) => {

    const saveErc20 = m.contract("SaveERC20", [tokenAddress]);

    return { saveErc20 };
});

export default SaveERC20Module;


// Deployed SaveERC20: 0xb227606E0350aB106ff8A608d50A537F63dEeAa4
