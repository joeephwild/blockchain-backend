// Import the necessary modules
const { expect } = require("chai");

describe("Consciousness", function () {
  let consciousness;
  let owner;
  let premiumContract;

  beforeEach(async function () {
    // Deploy the Consciousness contract
    const Consciousness = await ethers.getContractFactory("Consciousness");
    consciousness = await Consciousness.deploy();
    await consciousness.deployed();

    // Get the accounts
    [owner] = await ethers.getSigners();

    // Set the premium contract address
    premiumContract = "0xd9145CCE52D386f254917e481eB44e9943F39138";
  });

  it("should propose and vote for content", async function () {
    // Propose content
    await consciousness.proposeContent(
      "image",
      "title",
      "description",
      "category"
    );

    // Get the proposed content
    const allContent = await consciousness.getAllContent();
    const proposedContent = allContent[0];

    // Vote for the content
    await consciousness.connect(owner).voteContent(
      proposedContent.contentOwner,
      proposedContent.id
    );

    // Check if the content is approved
    const isApproved = await consciousness.checkIfApproved(
      proposedContent.contentOwner,
      proposedContent.id
    );

    // Assert that the content is approved
    expect(isApproved).to.be.true;
  });
});