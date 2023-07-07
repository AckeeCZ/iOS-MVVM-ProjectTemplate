import Combine
import Foundation

public final class Async<T> {
    public let task: () async throws -> T
    
    public var publisher: AnyPublisher<T, Error> {
        Deferred { [task] in
            Future<T, Error> { [task] promise in
                Task {
                    do {
                        let result = try await task()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public init(task: @escaping () async throws -> T) {
        self.task = task
    }
    
    public func map<U>(_ transform: @escaping (T) -> U) -> Async<U> {
        attemptMap(transform)
    }
    
    public func attemptMap<U>(_ transform: @escaping (T) throws -> U) -> Async<U> {
        .init { [task] in
            try await transform(task())
        }
    }
}

