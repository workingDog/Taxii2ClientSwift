//
//  PMKCollection.swift
//  Taxii2Swift
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
class PMKCollection {
    
    let taxiiCollection: TaxiiCollection
    let api_root: String
    let conn: PMKNetConnection
    let basePath: String
    let thePath: String
    
    init(taxiiCollection: TaxiiCollection, api_root: String, conn: PMKNetConnection)  {
        self.taxiiCollection = taxiiCollection
        self.api_root = PMKNetConnection.withLastSlash(api_root)
        self.conn = conn
        self.basePath = self.api_root + "collections/" + self.taxiiCollection.id
        self.thePath = self.basePath + "/objects/"
    }

    // taxii 2.1
    func getEnvelope() -> Promise<TaxiiEnvelope?> {
        return conn.fetchThis(path: thePath, headerType: 1, taxiiType: TaxiiEnvelope.self)
    }
    
    func getBundle() -> Promise<TaxiiBundle?> {
        return conn.fetchThis(path: thePath, headerType: 1, taxiiType: TaxiiBundle.self)
    }
    
//    func getEnvelope() -> Promise<TaxiiEnvelope?> {
//        self.getRaw().compactMap { data in
//            TaxiiHelper.taxiiEnvelope(from: data)
//        }
//    }
    
    // taxii2.0
//    func getTaxiiBundle() -> Promise<TaxiiBundle?> {
//        self.getRaw().compactMap { data in
//            TaxiiHelper.taxiiBundle(from: data)
//        }
//    }
 
//    func getBundle() -> Promise<Bundle?> {
//        self.getRaw().compactMap { data in
//            TaxiiHelper.stixBundle(from: data)
//        }
//    }

    //    func getObjects(obj_id: String) -> Promise<StixObject?> {
    //        return conn.fetchThis(path: thePath + obj_id + "/", headerType: 1, taxiiType: StixObject.self)
    //    }
    
    
    // returns the raw json data
    func getRaw() -> Promise<Data> {
        return conn.fetchRaw(path: thePath, headerType: 1)
    }

    func getManifests(bundle: TaxiiManifestRecord) -> Promise<TaxiiManifestRecord?> {
        return conn.fetchThis(path: thePath + "manifest/", taxiiType: TaxiiManifestRecord.self)
    }
 
    // taxii2.0
    func addObjects(bundle: TaxiiBundle) -> Promise<TaxiiStatus?> {
        let jsonData = (try? JSONSerialization.data(withJSONObject: bundle)) ?? Data()
        return conn.postThis(path: thePath, jsonData: jsonData, taxiiType: TaxiiStatus.self)
    }
    
    func addObjects(envelope: TaxiiEnvelope) -> Promise<TaxiiStatus?> {
        let jsonData = (try? JSONSerialization.data(withJSONObject: envelope)) ?? Data()
        return conn.postThis(path: thePath, jsonData: jsonData, taxiiType: TaxiiStatus.self)
    }
      
}
