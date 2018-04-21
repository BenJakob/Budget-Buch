//
//  PurchaseManager.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 25.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    let IAP_REMOVE_ADS = "com.fenox.Budget-Buch.removeAds"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    
    func fetchProducts() {
        print("###### fetchProducts #######")
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("###### productsRequest #######")
        print("###### Count: \(response.products.count) #######")
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}

