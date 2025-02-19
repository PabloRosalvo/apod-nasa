import Foundation

public enum NetworkResult<T> {
    case success(T)
    case failure(RequestError)

    public var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    public var isFailure: Bool {
        !isSuccess
    }

    public var value: T? {
        if case .success(let value) = self { return value }
        return nil
    }

    public var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }
}

