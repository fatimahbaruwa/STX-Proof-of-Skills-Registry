Proof-of-Skills Registry Smart Contract

Overview

The Proof-of-Skills Registry is a Clarity-based smart contract on the Stacks blockchain that issues and manages verifiable skill credentials as NFTs. Each NFT represents a verified coding challenge, test completion, or skill certification, tied immutably to a blockchain identity. This enables developers, employers, and institutions to confirm skill authenticity without relying on centralized verification services.

✨ Features

NFT Minting: The contract owner can mint skill-proof tokens for recipients, encoding skill type, skill name, verification hash, and completion date.

Ownership Management: Each token is linked to an owner and can be transferred securely to another principal.

Verification: Anyone can query a token to verify its skill details and authenticity.

Token Tracking: Maintains a registry of tokens per owner and overall minted tokens.

Immutable Record: Completion date is tied to the blockchain block-height, ensuring time-stamped proof.

🔑 Key Functions
Public Functions

(mint-skill-proof recipient skill-type skill-name verification-hash)
Mints a new skill-proof NFT for a recipient. Only the contract owner can call this function.

(transfer token-id sender recipient)
Transfers ownership of a skill-proof NFT from one user to another.

(verify-skill token-id)
Returns structured details about a skill-proof, including owner, skill type, and verification hash.

Read-Only Functions

(get-last-token-id) → Returns the latest minted token ID.

(get-token-info token-id) → Fetches details of a specific token.

(get-owner-tokens owner) → Returns a list of token IDs owned by a given principal.

(get-token-owner token-id) → Returns the owner of a specific token.

⚙️ Data Structures

tokens: Maps each token-id → NFT metadata (owner, skill type, skill name, completion date, hash, verifier).

token-owners: Maps token-id → current owner.

owner-tokens: Maps owner → list of owned token IDs (up to 100).

last-token-id: Tracks the latest minted token ID.

🚀 Usage Example

Mint a Proof

(contract-call? .proof-of-skills mint-skill-proof 
    'SP1234... 
    "Blockchain Development"
    "Stacks Smart Contract Certification"
    "abc123hashvalue"
)


Verify a Skill

(contract-call? .proof-of-skills verify-skill u1)


Transfer Proof

(contract-call? .proof-of-skills transfer u1 'SP1234... 'SP5678...)

🔒 Access Control

Contract Owner Only: Can mint new skill proofs.

Token Owner Only: Can transfer their NFT.

Everyone: Can verify skill proofs or query registry data.

📌 Use Cases

Blockchain-based skill certification registry.

Education platforms issuing verifiable certificates.

Recruitment processes for confirming developer/test credentials.

DAOs or communities recognizing contributions with immutable skill badges.

✅ Requirements

Stacks blockchain & Clarity runtime.

Deployed via Clarinet
 for testing and local development.

📜 License

MIT License