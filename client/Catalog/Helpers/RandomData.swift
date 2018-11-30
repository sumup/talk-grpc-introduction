//
//  GICProduct+RandomData.swift
//  Catalog
//
//  Created by Stanislav Zahariev on 30.11.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import Foundation

class RandomData {
    private static var sequence = 0
    
    static func randomProduct() -> GICProduct {
        sequence += 1
        return GICProduct(name: "Name \(sequence)", description: "Description \(sequence)", price: Double.init(sequence))
    }

    static func randomImage() -> UIImage {
        return UIImage(named: "product\(Int(Double(sequence).truncatingRemainder(dividingBy: 5)))")!
    }
}
