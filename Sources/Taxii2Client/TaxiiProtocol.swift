//
//  TaxiiProtocol.swift
//  Taxii2Client
//
//  Created by Ringo Wathelet on 2020/03/21.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import GenericJSON

// TAXII-2.1 protocol

/*
 * The discovery resource contains information about a TAXII Server,
 * such as a human-readable title, description, and contact information,
 * as well as a list of API Roots that it is advertising.
 * It also has an indication of which API Root it considers the default,
 * or the one to use in the absence of other information/user choice.
 */
struct TaxiiDiscovery: Codable {
    let title: String
    let description: String?
    let contact: String?
    let default_api: String?
    let api_roots: [String]?
    
    private enum CodingKeys : String, CodingKey {
        case title, default_api = "default", description, contact, api_roots
    }
}

/*
 * The api-root resource contains general information about the API Root,
 * such as a human-readable title and description, the TAXII versions it supports,
 * and the maximum size of the content body it will accept in a PUT or POST (max_content_length).
 */
struct TaxiiApiRoot: Codable {
    let title: String
    let versions: [String]
    let max_content_length: UInt64
    let description: String?
}

/* Taxii-2.0 only
 * This type represents an object that was not added to the Collection.
 */
struct TaxiiStatusFailure: Codable {
    let id: String
    let message: [String]?
}

/*
 * This type represents an object that was not added to the Collection.
 */
struct TaxiiStatusDetails: Codable {
    let id: String
    let version: String
    let message: [String]?
}

/*
 * The status resource represents information about a request to add objects to a Collection.
 */
struct TaxiiStatus: Codable {
    let id: String
    let status: String
    let total_count: UInt64
    let success_count: UInt64
    let failure_count: UInt64
    let pending_count: UInt64
    let request_timestamp: String?
    let failures: [TaxiiStatusDetails]?
    let pendings: [TaxiiStatusDetails]?
    let successes: [TaxiiStatusDetails]?
}

/*
 * The error message is provided by TAXII Servers in the response body when
 * returning an HTTP error status and contains more information describing the error,
 * including a human-readable title and description, an error_code and error_id,
 * and a details structure to capture further structured information about the error.
 */
struct TaxiiErrorMessage: Codable {
    let title: String
    let description: [String]?
    let error_id: [String]?
    let error_code: [String]?
    let http_status: [String]?
    let external_details: [String]?
    let details: [String:String]?
}

/*
 * The collection resource contains general information about a Collection,
 * such as its id, a human-readable title and description,
 * an optional list of supported media_types
 * (representing the media type of objects can be requested from or added to it),
 * and whether the TAXII Client, as authenticated, can get objects from
 * the Collection and/or add objects to it.
 */
struct TaxiiCollection: Codable {
    let id: String
    let title: String
    let can_read: Bool
    let can_write: Bool
    let description: String?
    let alias: String?
    let media_types: [String]?
}

/*
 * The collections resource is a simple wrapper around a list of collection resources.
 */
struct TaxiiCollections: Codable {
    let collections: [TaxiiCollection]?
}

/* Taxii-2.0 only
 * The manifest-entry type captures metadata about a single object, indicated by the id property.
 */
struct TaxiiManifestEntry: Codable {
    let id: String 
    let date_added: [String]?
    let versions: [String]?
    let media_types: [String]?
}

/*
 * The manifest-record type captures metadata about a single object, indicated by the id property.
 */
struct TaxiiManifestRecord: Codable {
    let id: String
    let date_added: [String]
    let versions: [String]
    let media_types: [String]?
}

/*
 * The URL Filtering Parameters
 */
struct TaxiiFilters: Codable {
    let added_after: String?
    let limit: Int?
    let next: String?
    let id: [String]?
    let type: [String]?
    let version: [String]?
    let spec_version: [String]?
    
    init(added_after: String? = nil, limit: Int? = nil, next: String? = nil, id: [String]? = nil, type: [String]? = nil,
         version: [String]? = nil, spec_version: [String]? = nil) {
        self.added_after = added_after
        self.limit = limit
        self.next = next
        self.id = id
        self.type = type
        self.version = version
        self.spec_version = spec_version
    }
    
    func asParameters() -> [String:String] {
        var params = [String:String]()
        
        if self.added_after != nil { params["added_after"] = added_after }
        if self.limit != nil { params["limit"] = "\(limit!)" }
        if self.next != nil { params["next"] = next }

        if self.id != nil {
            params["match[id]"] = self.id!.joined(separator: ",")
        }
        if self.type != nil {
            params["match[type]"] = self.type!.joined(separator: ",")
        }
        if self.version != nil {
            params["match[version]"] = self.version!.joined(separator: ",")
        }
        if self.spec_version != nil {
            params["match[spec_version]"] = self.spec_version!.joined(separator: ",")
        }

        return params
    }
}

/*
 * The manifest resource is a simple wrapper around a list of manifest-record items.
 */
struct TaxiiManifestResource: Codable {
    let more: Bool?
    let objects: [TaxiiManifestRecord]?
}

/*
 * The versions resource is a simple wrapper around a list of versions.
 */
struct TaxiiVersionResource: Codable {
    let more: Bool?
    let versions: [String]?
}

/* Taxii-2.0 only
 * The bundle is a simple wrapper for STIX 2.0 content.
 */
struct TaxiiBundle: Codable {
    let type: String
    let id: String
    let spec_version: String
    let objects: [JSON]?
}

/*
 * The envelope is a simple wrapper for STIX 2.1 content.
 * When returning STIX 2.1 content in a TAXII-2.1 response the HTTP root object payload MUST be an envelope.
 */
struct TaxiiEnvelope: Codable {
    let more: Bool?
    let next: String?
    let objects: [JSON]?
}
