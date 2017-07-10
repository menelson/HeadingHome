//
//  PermissionFactory.swift
//  MNPermissionService
//
//  Created by Mike Nelson on 6/29/17.
//
//

import Foundation

protocol MNPermissionFactory {
    associatedtype EntityType
    associatedtype StoreType
    
    var store: StoreType { get }
    var entity: EntityType { get }
    var message: String { get }
    var title: String { get }
    
    func requestUserAccess(completionHandler: @escaping (Bool) -> Void)
}
