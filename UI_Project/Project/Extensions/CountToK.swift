//
//  CountToK.swift
//  UI_Project
//
//  Created by Shisetsu on 02.08.2021.
//

import Foundation

func formatCounts(_ n: Double, completion: @escaping(String)->()){
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        completion ("\(sign)\(formatted)B")

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        completion ("\(sign)\(formatted)M")

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        completion ("\(sign)\(formatted)K")

    case 0...:
        completion (String(n).replacingOccurrences(of: ".0", with: ""))

    default:
        completion ("\(sign)\(n)")
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
