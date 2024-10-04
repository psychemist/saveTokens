import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SaveEtherModule = buildModule("SaveEtherModule", (m) => {

    const saveEther = m.contract("SaveEther");

    return { saveEther };
});

export default SaveEtherModule;

// Deployed SaveEther: 0x15A2B47A9B41cAE11804Dd99bfB60862183c5eF8
