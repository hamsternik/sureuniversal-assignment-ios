//
//  Color+Extensions.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

extension Color {
    struct Primary {
        static let background = Color("primary.background", bundle: .main)
        static let foreground = Color("primary.foreground", bundle: .main)
    }
    
    struct Secondary {
        static let background = Color("secondary.background", bundle: .main)
        static let foreground = Color("secondary.foreground", bundle: .main)
    }
}
