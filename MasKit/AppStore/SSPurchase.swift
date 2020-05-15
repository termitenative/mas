//
//  SSPurchase.swift
//  mas-cli
//
//  Created by Andrew Naylor on 25/08/2015.
//  Copyright (c) 2015 Andrew Naylor. All rights reserved.
//

import CommerceKit
import StoreFoundation

typealias SSPurchaseCompletion =
    (_ purchase: SSPurchase?, _ completed: Bool, _ error: Error?, _ response: SSPurchaseResponse?) -> Void

extension SSPurchase {
    convenience init(adamId: UInt64, account: ISStoreAccount, isPurchase: Bool) {
        self.init()

		var parameters: [String: Any] = [
			"productType": "C",
			"price": 0,
			"salableAdamId": adamId,
			"pg": "default",
			"appExtVrsId": 0
		]

        if isPurchase {
			parameters["macappinstalledconfirmed"] = 1
			parameters["pricingParameters"] = "STDQ"

        } else {
            // is redownload, use existing functionality
			parameters["pricingParameters"] = "STDRDL"
        }

		buyParameters = parameters.map { key, value in
			return "\(key)=\(value)"
		}.joined(separator: "&")

        itemIdentifier = adamId
        accountIdentifier = account.dsID
        appleID = account.identifier

        // Not sure if this is needed, but lets use it here.
        if isPurchase {
            isRedownload = false
        }

        let downloadMetadata = SSDownloadMetadata()
        downloadMetadata.kind = "software"
        downloadMetadata.itemIdentifier = adamId

        self.downloadMetadata = downloadMetadata
    }

    func perform(_ completion: @escaping SSPurchaseCompletion) {
        CKPurchaseController.shared().perform(self, withOptions: 0, completionHandler: completion)
    }
}