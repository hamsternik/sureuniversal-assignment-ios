//
//  Command.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import Foundation

/// A developer-friendly wrapper around a closure.
/// Every command always has Void result type, which do it less composable, but also more focused.
public final class CommandWith<T>: Identifiable {
    public let id: String
    private let file: StaticString
    private let function: StaticString
    private let line: Int
    private let action: (T) -> Void
    
    public init(
        id: String = UUID().uuidString,
        file: StaticString = #file,
        function: StaticString = #function,
        line: Int = #line,
        action: @escaping (T) -> Void
    ) {
        self.id = id
        self.file = file
        self.function = function
        self.line = line
        self.action = action
    }
    
    public func perform(with value: T) {
        action(value)
    }
    
    public static var nop: CommandWith<T> {
        CommandWith(id: "nop") { _ in }
    }
}

extension CommandWith: Hashable {
    public static func == (lhs: CommandWith, rhs: CommandWith) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CommandWith {
    public func bind(to value: T, id: String) -> Command {
        Command(id: id) { [action] in action(value) }
    }
    
    public func bind(to value: T) -> Command {
        bind(to: value, id: UUID().uuidString)
    }
}

extension CommandWith {
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        map(transform: transform, id: UUID().uuidString)
    }
    
    func map<U>(transform: @escaping (U) -> T, id: String) -> CommandWith<U> {
        CommandWith<U>(id: id) { [action] u in action(transform(u)) }
    }
}

extension CommandWith {
    public func dispatched(on queue: DispatchQueue) -> CommandWith {
        CommandWith { [action] value in
            queue.async {
                action(value)
            }
        }
    }
}

extension CommandWith {
    /// Creates a new command which performs 2 commands: current command at frist and *another* command, passed as parameter.
    func then(_ another: CommandWith, id: String) -> CommandWith {
        return CommandWith(id: id) { [action, another = another.action] value in
            action(value)
            another(value)
        }
    }
    
    func then(_ another: CommandWith) -> CommandWith {
        then(another, id: UUID().uuidString)
    }
}

public typealias Command = CommandWith<Void>

public extension CommandWith where T == Void {
    func perform() {
        perform(with: ())
    }
}
