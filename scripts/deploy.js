async function main() {
  const Voting = await ethers.getContractFactory("Voting");

  // Start deployment, passing the candidate names and duration
  const Voting_ = await Voting.deploy(
    ["Dhruv Pancholi", "Rahul", "Modi", "Mamta"],  // List of candidate names
    1300  // Duration in minutes
  );

  console.log("Contract address:", Voting_.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
