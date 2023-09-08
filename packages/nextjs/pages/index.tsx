import Image from "next/image";
import Link from "next/link";
import type { NextPage } from "next";
import { MetaHeader } from "~~/components/MetaHeader";

const Home: NextPage = () => {
  return (
    <>
      <MetaHeader />
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center mb-8">
            <span className="block text-2xl mb-2">Welcome to</span>
            <span className="block text-4xl font-bold">Food Scramble</span>
          </h1>
          <Image className="ml-14" alt="Game" width={400} height={400} src="/assets/game.png" />
          <p className="text-center text-lg">Collect ingredients, combine them, and create unique food NFTs </p>
          <div className="flex justify-center mb-6">
            <Link
              href="/example-ui"
              passHref
              className=" py-2 px-16 mb-1 mt-3 bg-green-500 rounded baseline hover:bg-green-300 disabled:opacity-50"
            >
              Play
            </Link>
          </div>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="text-center">
            <h2 className="mt-3 text-4xl">How to play?</h2>
          </div>
          <div className="flex justify-center">
            <ul className="list-disc" style={{ width: "600px" }}>
              <li>Player can roll a six-sided dice to move</li>
              <li>If it&apos;s an ingredient space, you can buy it</li>
              <li>If it&apos;s a rail space, you can travel to other side</li>
              <li>Once you have the required ingredients for a food NFT card, you can combine them to create a NFT</li>
            </ul>
          </div>
          <p className="text-3xl text-center">Requirements</p>
          <div className="flex justify-center">
            <ul className="list-disc" style={{ width: "600px" }}>
              <li>You must have an NFT and created an Token Bound Account</li>
            </ul>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
