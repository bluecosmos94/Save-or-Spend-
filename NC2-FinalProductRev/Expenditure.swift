//
//  Expenditure.swift
//  NC2-FinalProductRev
//
//  Created by Kelny Tan on 11/04/21.
//

import Foundation
struct Expenditure
{
    let itemName: String!
    var qtyItem: Int!
    var pricePerItem: Double!
    
    func total() -> Double{
        return Double(qtyItem) * pricePerItem
    }
}
