import { BOARD_STYLES } from "./style";
import { useAccount } from "wagmi";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export const Board = () => {
  const { address } = useAccount();

  const { writeAsync: createAccount } = useScaffoldContractWrite({
    contractName: "ERC6551Registry",
    functionName: "createAccount",
    args: [
      "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
      BigInt("1"),
      "0x5FbDB2315678afecb367f032d93F642f64180aa3",
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
            <button
              className="py-2 px-16 mb-1 mt-3 mr-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
              onClick={() => createAccount()}
            >
              Play
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
