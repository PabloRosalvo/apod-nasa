import Foundation

extension Date {
    func toYYYYMMDD(in timeZone: TimeZone? = TimeZone(identifier: "America/Sao_Paulo")) -> String {
        let safeTimeZone = timeZone ?? TimeZone.current
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: safeTimeZone, from: self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = safeTimeZone
        formatter.locale = Locale(identifier: "pt_BR")
        guard let date = calendar.date(from: components) else { return formatter.string(from: self) }
        return formatter.string(from: date)
    }
    
    static func fromYYYYMMDD(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: dateString)
    }
}
