//
//  PMKStatus.swift
//  Taxii2Swift
//
//  Created by Ringo Wathelet on 2020/03/22.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit


/*
 * This Endpoint provides information about the status of a previous request.
 *
 * @param conn the connection to the Taxii-2.x server
 */
class PMKStatus {
    
    let api_root: String
    let status_id: String
    let conn: PMKNetConnection
    let thePath: String
    
    init(api_root: String, status_id: String, conn: PMKNetConnection) {
        self.api_root = PMKNetConnection.withLastSlash(api_root)
        self.status_id = status_id
        self.conn = conn
        self.thePath = self.api_root + "status/" + self.status_id + "/"
    }

    func get() -> Promise<TaxiiStatus?> {
        return conn.fetchThis(path: thePath, taxiiType: TaxiiStatus.self)
    }
    
}
