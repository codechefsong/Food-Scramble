import { useState } from "react";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import deployedContracts from "~~/generated/deployedContracts";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const CHAIN_ID = 31337;

const Marketplace: NextPage = () => {
  const { address } = useAccount();

  const [selectedNFT, setSelectNFT] = useState(-1);

  const { data: nfts } = useScaffoldContractRead({
    contractName: "FoodNFT",
    functionName: "getMyNFTs",
    args: [address],
  });

  const { writeAsync: mintNFT } = useScaffoldContractWrite({
    contractName: "FoodNFT",
    functionName: "mint",
    args: [address, "URL"],
    onBlockConfirmation: txnReceipt => {
      console.log("📦 Transaction blockHash", txnReceipt.blockHash);
    },
  });

  const { writeAsync: createAccount } = useScaffoldContractWrite({
    contractName: "FoodScramble",
    functionName: "createTokenBoundAccount",
    args: [
      deployedContracts[CHAIN_ID][0].contracts.ERC6551Account.address,
      BigInt("1"),
      deployedContracts[CHAIN_ID][0].contracts.FoodNFT.address,
      BigInt(selectedNFT),
      BigInt("1"),
      "0x",
    ],
    onBlockConfirmation: txnReceipt => {
      console.log("📦 Transaction blockHash", txnReceipt.blockHash);
      console.log(txnReceipt);
    },
  });

  return (
    <div className="flex items-center flex-col flex-grow pt-7">
      <div className="px-5">
        <h1 className="text-center mb-5">
          <span className="block text-3xl mb-2">Select your NFTs</span>
        </h1>

        <div className="flex">
          {nfts?.map((n, index) => (
            <div
              key={index}
              className="w-16 h-20 border border-gray-30 flex items-center justify-center font-bold mr-2 mb-2 cursor-pointer"
              style={{ background: selectedNFT === index ? "#00cc99" : "white" }}
              onClick={() => setSelectNFT(index)}
            >
              {n.toString()}
            </div>
          ))}
        </div>

        <button
          className="py-2 px-16 mb-10 mt-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
          onClick={() => createAccount()}
          disabled={nfts?.length === 0 || selectedNFT === -1}
        >
          Create Token Bound Account
        </button>
        <h1 className="text-center mb-5">
          <span className="block text-2xl mb-2">Buy a NFT</span>
        </h1>

        <button
          className="py-2 px-16 mb-1 mt-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
          onClick={() => mintNFT()}
        >
          Buy
        </button>
      </div>
    </div>
  );
};

export default Marketplace;
