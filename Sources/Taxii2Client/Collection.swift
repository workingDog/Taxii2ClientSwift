//
//  Collection.swift
//  Taxii2Client
//
//  Created by Ringo Wathelet on 2020/03/22.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit


/*
 * This Endpoint provides general information about a Collection, which can be used to help
 * users and clients decide whether and how they want to interact with it.
 *
 * @param conn the connection to the Taxii-2.x server
 */
class Collection {
    
    let taxiiCollection: TaxiiCollection
    let api_root: String
    let conn: TaxiiConnection
    let basePath: String
    let thePath: String
    
    init(taxiiCollection: TaxiiCollection, api_root: String, conn: TaxiiConnection)  {
        self.taxiiCollection = taxiiCollection
        self.api_root = TaxiiConnection.withLastSlash(api_root)
        self.conn = conn
        self.basePath = self.api_root + "collections/" + self.taxiiCollection.id
        self.thePath = self.basePath + "/objects/"
    }

    // taxii 2.1
    func getEnvelope() -> Promise<TaxiiEnvelope?> {
        return conn.fetchThis(path: thePath, headerType: 1, taxiiType: TaxiiEnvelope.self)
    }
    
    // taxii-2.0
    func getBundle() -> Promise<TaxiiBundle?> {
        return conn.fetchThis(path: thePath, headerType: 1, taxiiType: TaxiiBundle.self)
    }

    // todo
    //    func getObjects(filters: TaxiiFilters? = nil) -> Promise<StixObject?> {
    //
    //            if let theFilters = filters {
    //                return conn.fetchThisWithFilters(path: thePath + "objects/", filters: theFilters, taxiiType: StixObject.self)
    //            } else {
    //                 return conn.fetchThis(path: thePath + "objects/", headerType: 1, taxiiType: StixObject.self)
    //            }
    //        }
    //    }
    
    // todo
    //    func getObject(obj_id: String, filters: TaxiiFilters? = nil) -> Promise<StixObject?> {
    //
    //            if let theFilters = filters {
    //                return conn.fetchThisWithFilters(path: thePath + obj_id + "/", filters: theFilter, taxiiType: StixObject.self)
    //            } else {
    //                 return conn.fetchThis(path: thePath + obj_id + "/", headerType: 1, taxiiType: StixObject.self)
    //            }
    //        }
    //    }
    
    // todo
    //    func getObjectVersions(obj_id: String, filters: TaxiiFilters? = nil) -> Promise<[String]> {
    //
    //            if let theFilters = filters {
    //                return conn.fetchThisWithFilters(path: thePath + obj_id + "/versions/", filters: theFilters, taxiiType: [String].self)
    //            } else {
    //                 return conn.fetchThis(path: thePath + obj_id + "/versions/", headerType: 1, taxiiType: [String].self)
    //            }
    //        }
    //    }

    // returns the raw json data
    func getRaw() -> Promise<Data> {
        return conn.fetchRaw(path: thePath, headerType: 1)
    }
 
    func getManifests(filters: TaxiiFilters? = nil) -> Promise<TaxiiManifestRecord?> {
        if let theFilters = filters {
            return conn.fetchThisWithFilters(path: thePath + "manifest/", filters: theFilters, taxiiType: TaxiiManifestRecord.self)
        } else {
            return conn.fetchThis(path: thePath + "manifest/", taxiiType: TaxiiManifestRecord.self)
        }
    }

    // taxii-2.0
    func addObjects(bundle: TaxiiBundle) -> Promise<TaxiiStatus?> {
        let jsonData = (try? JSONSerialization.data(withJSONObject: bundle)) ?? Data()
        return conn.postThis(path: thePath, jsonData: jsonData, taxiiType: TaxiiStatus.self)
    }
    
    func addObjects(envelope: TaxiiEnvelope) -> Promise<TaxiiStatus?> {
        let jsonData = (try? JSONSerialization.data(withJSONObject: envelope)) ?? Data()
        return conn.postThis(path: thePath, jsonData: jsonData, taxiiType: TaxiiStatus.self)
    }
      
}
