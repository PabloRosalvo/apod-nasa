import Foundation

public enum APIEndpoint: EndPointType {
    case apodByDate(date: String)
    case apodRandom(count: Int)
    case apodByRange(startDate: String, endDate: String, thumbs: Bool)
    
    public var path: String {
        return "/planetary/apod"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    public var queryParameters: [String: Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case let .apodByDate(date):
            params["date"] = date
            
        case let .apodRandom(count):
            params["count"] = count
            
        case let .apodByRange(startDate, endDate, thumbs):
            params["start_date"] = startDate
            params["end_date"] = endDate
            if thumbs { params["thumbs"] = "true" }
        }
        
        return params
    }
}
