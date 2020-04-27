//
//  ApiRoot.swift
//  Taxii2Client
//
//  Created by Ringo Wathelet on 2020/03/22.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit


/*
 * This Endpoint provides general information about an API Root,
 * which can be used to help users and clients decide whether and how they want to interact with it.
 *
 * @param api_root the api_root path of this ApiRoot request
 * @param conn     the connection to the Taxii-2.x server
 */
class ApiRoot {
    
    let api_root: String
    let conn: TaxiiConnection
    
    init(api_root: String, conn: TaxiiConnection) {
        self.api_root = TaxiiConnection.withLastSlash(api_root)
        self.conn = conn
    }
    
    func get() -> Promise<TaxiiApiRoot?> {
        return conn.fetchThis(path: api_root, taxiiType: TaxiiApiRoot.self)
    }
    
    func collections() -> Promise<TaxiiCollections?> {
        return Collections(api_root: api_root, conn: conn).get()
    }
    
    func collections(index: Int) -> Promise<TaxiiCollection?> {
        self.collections().compactMap { cols in
            cols?.collections?[index]
        }
    }
    
    func status(status_id: String) -> Promise<TaxiiStatus?> {
        return Status(api_root: api_root, status_id: status_id, conn: conn).get()
    }
    
}

