import { BOARD_STYLES } from "./style";
import { useAccount, useNetwork } from "wagmi";
import deployedContracts from "~~/generated/deployedContracts";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const Board = () => {
  const { address } = useAccount();
  const { chain } = useNetwork();

  const { data: tbaAddress } = useScaffoldContractRead({
    contractName: "FoodScramble",
    functionName: "tbaList",
    args: [address],
  });

  const { writeAsync: createAccount } = useScaffoldContractWrite({
    contractName: "FoodScramble",
    functionName: "createTokenBoundAccount",
    args: [
      deployedContracts[chain?.id][0].contracts.ERC6551Account.address,
      BigInt("1"),
      deployedContracts[chain?.id][0].contracts.FoodNFT.address,
      BigInt("0"),
      BigInt("1"),
      "0x",
    ],
    onBlockConfirmation: txnReceipt => {
      console.log("📦 Transaction blockHash", txnReceipt.blockHash);
      console.log(txnReceipt);
    },
  });

  return (
    <div className="mt-5">
      <div>
        <div className="flex">
          <div>
            <h2 className="mt-4 text-3xl">Board</h2>
            <p>{address}</p>
            <p>{tbaAddress}</p>
            <button
              className="py-2 px-16 mb-1 mt-3 mr-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
              onClick={() => createAccount()}
            >
              Create
            </button>
            <button
              className="py-2 px-16 mb-1 mt-3 mr-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
              onClick={() => console.log("roll")}
            >
              Roll
            </button>
            <div className="relative mt-3" style={{ width: "450px", height: "600px" }}>
              {BOARD_STYLES &&
                BOARD_STYLES.map((item, index) => (
                  <div
                    key={index}
                    className={
                      "w-20 h-20 border border-gray-300 font-bold bg-white" + " " + BOARD_STYLES[index] || "grid-1"
                    }
                  >
                    {item}
                  </div>
                ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
