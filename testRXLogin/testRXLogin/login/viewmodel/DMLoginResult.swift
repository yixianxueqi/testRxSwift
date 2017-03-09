//
//  DMLoginResult.swift
//  testRXLogin
//
//  Created by 君若见故 on 17/3/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {

    var description: String {
        switch self {
        case let .ok(message): return message
        case .empty: return ""
        case .validating: return "验证中..."
        case let .failed(message): return message
        }
    }
}

extension ValidationResult {

    var textColor: UIColor {
        switch self {
        case .ok: return ValidationColors.okColor
        case .failed: return ValidationColors.errorColor
        default:
            return UIColor.black
        }
    }
}

extension Reactive where Base: UILabel {

    var validationResult: UIBindingObserver<Base, ValidationResult> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}


















