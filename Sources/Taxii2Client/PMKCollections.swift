//
//  PMKCollections.swift
//  Taxii2Swift
//
//  Created by Ringo Wathelet on 2020/03/22.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit


/*
 * This Endpoint provides information about the Collections hosted under this API Root.
 *
 * @param conn the connection to the Taxii-2.x server
 */
class PMKCollections {
    
    let api_root: String
    let conn: PMKNetConnection
    let thePath: String
    
    init(api_root: String, conn: PMKNetConnection)  {
        self.api_root = PMKNetConnection.withLastSlash(api_root)
        self.conn = conn
        self.thePath = self.api_root + "collections/"
    }
    
    func get() -> Promise<TaxiiCollections?> {
        return conn.fetchThis(path: thePath, taxiiType: TaxiiCollections.self)
    }
    
    func get(index: Int) -> Promise<TaxiiCollection?> {
        self.get().compactMap { cols in
            cols?.collections?[index]
        }
    }
    
    func getRaw() -> Promise<Data> {
        return conn.fetchRaw(path: thePath)
    }
    
}
