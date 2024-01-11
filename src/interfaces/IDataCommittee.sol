// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.23;

///////////////////////////////////////////////////////
// Dependencies 
///////////////////////////////////////////////////////
import {CommonTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";

///////////////////////////////////////////////////////
// Errors 
///////////////////////////////////////////////////////

// This error is triggered when a storage provider that
// is not on the allow list attempts to authenticate a
// deal with the data committee.
error UnauthorizedStorageProvider();

/**
 * Sashimi Data Committee 
 *
 * A Data committee manages the following use cases:
 *    + Managing allow lists for storage providers and data providers
 *    + Controls data cap and Filecoin fund bounties
 *
 * This implementation is intended to interact with two other interfaces,
 * one for the data provider interface (by providing data) and one
 * for the storage provider (who will authorize storage deals using
 * the committee as a client).
 *
 * It is inferred that only data committee members can access these. Access control
 * mechanisms are not explicitly defined here, and can be implementation specific.
 */
interface IDataCommittee {
		
	///////////////////////////////////////////////////////
    // Events
    ///////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////
    // Data and Storage Provider Allowlist Management 
    ///////////////////////////////////////////////////////
   	enum AllowListType {
		// only specific allowed storage providers can authenticate deals
		// with this client and collect and use data cap.
		STORAGE_PROVIDER,

		// We do not have a block oracle from a target data source,
		// so for simplicity we are going to explicitly trust
		// data providers to post CIDs/IPFS locations for storage.
		DATA_PROVIDER
	}

	/**
     * changeAllowListStatus
     *
     * A data committee memeber can call this function to add or remove specific
     * filecoin actors from being an authorized storage provider or data provider.
	 *
	 * For simplicity, if the actor already exists when adding, or doesn't exist when removing, will
	 * silently be a no-op, and will not fail or otherwise revert.
	 *
	 * @param listType denoting whether the action is for storaage providers, or data providers.
	 * @param actor    the encoded filecoin of the address of the actor.
	 * @param allowed  true if you want to add them to the list, false to remove.
	 */ 
	function changeAllowListStatus(AllowListType listType, CommonTypes.FilAddress calldata actor, bool allowed) external;

	///////////////////////////////////////////////////////
    // Data Cap and Bounty Management 
    ///////////////////////////////////////////////////////
	
	/**
	 * handle_filecoin_method
	 *
	 * This interface is responsible for receiving data cap, notifying,
	 * and authenticating deals as a client. A data committee
	 * must handle all of these three cases properly.
	 */
	function handle_filecoin_method(uint64 method, uint64, bytes memory params) public returns (uint32, uint64, bytes memory);
}
