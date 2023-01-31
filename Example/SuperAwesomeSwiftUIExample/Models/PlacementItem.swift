//
//  PlacementItem.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import Foundation

struct PlacementItem: Identifiable, Hashable {
    let name: String?
    let type: FeatureType
    let placementId: Int
    let lineItemId: Int?
    let creativeId: Int?
    let id = UUID()

    init(name: String? = nil,
         type: FeatureType,
         placementId: Int,
         lineItemId: Int? = nil,
         creativeId: Int? = nil) {
        self.name = name
        self.type = type
        self.placementId = placementId
        self.lineItemId = lineItemId
        self.creativeId = creativeId
    }

    var title: String {
        name ?? "Default"
    }
}
