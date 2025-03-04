//
//  Color+Extensions.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

extension Color {
    struct Users {
        /// #EEEDF4
        static let contentBackground = Color("users.content.background", bundle: .main)
        /// #F7F5FA
        static let rootBackground = Color("users.root.background", bundle: .main)
    }
    
    struct User {
        /// #DEDDE4
        static let stroke = Color("user.container.stroke", bundle: .main)
    }
    
    struct Primary {
        static let background = Color("primary.background", bundle: .main)
        static let foreground = Color("primary.foreground", bundle: .main)
    }
    
    struct Secondary {
        static let background = Color("secondary.background", bundle: .main)
        static let foreground = Color("secondary.foreground", bundle: .main)
    }
}
