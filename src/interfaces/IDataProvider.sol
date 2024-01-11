// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.23;

///////////////////////////////////////////////////////
// Dependencies 
///////////////////////////////////////////////////////
import {CommonTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";

///////////////////////////////////////////////////////
// Errors 
///////////////////////////////////////////////////////

/**
 * Sashimi Data Provider 
 *
 * A Sashimi Data Provider is a trusted provider who runs a Sashimi Sidecar alongside
 * a data generation source. These Data Providers provide CIDs as well as URIs to IPFS
 * where data deals should be originated from. When an SP successfully seals the deal,
 * this data provider is rewarded with an optional bounty. This is part of the protocol,
 * but not part of the interface.
 */
interface IDataCommittee {
		
	///////////////////////////////////////////////////////
    // Events
    ///////////////////////////////////////////////////////

 	/**
     * DataProvided
     *
     * This event fires when an allowed data provider successfully
     * provides data for archival storage.
	 *
	 * These events are consumed by SPs for deal creation.
     *
     * @param operator the eth address of the message sender, the data provider.
     * @param cid      the raw bytes that describe the CID of the car file.
     * @param uri	   a utf-8 encoded string that points to an IPFS location.
     */	 
   	event DataProvided(address indexed operator, bytes cid, string uri);

    ///////////////////////////////////////////////////////
    // Data Commitments 
    ///////////////////////////////////////////////////////

	/**
	 * provideDataCommitment
	 *
	 * The data provider is trusted, so all that is needed by the client
	 * is the CID, and the URI for the IPFS location. This method will register
	 * this as something viable for both data cap and provisioning bounties.
	 *
	 * @param cid the cid of the data piece to be stored.
	 * @param uri the ipfs url where the data is temporarily located.
	 */
	function provideDataCommitment(CommonTypes.Cid calldata cid, string calldata uri) external;

	/**
	 * collectBounties
	 *
	 * This method is called by data providers to collect their FIL / tokens / etc
	 * as dictated by the state of the data committee.
	 *
	 * This method should send FIL or tokens to the message sender if the message sender
	 * is an allowed data provider and eligible for unlocked incentives.
	 */
	function collectBounties() external;
}
