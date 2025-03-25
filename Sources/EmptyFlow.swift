//
//  EmptyFlow.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

public struct EmptyFlow: View {
    public struct Props: Hashable {
        public let flowNumber: String
        public let title: String
        
        public init(flowNumber: String, title: String) {
            self.flowNumber = flowNumber
            self.title = title
        }
    }
    
    private var props: Props
    private let onBack: Command
    
    
    public init(props: Props, onBack: Command) {
        self.props = props
        self.onBack = onBack
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 56) {
                Text(props.flowNumber)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(props.title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.leading)
            Spacer()
        }
        .padding(.top, 40)
        .background(.background)
    }
}
