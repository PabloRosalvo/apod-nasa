import Foundation

public extension Bundle {
    func loadJsonData(fileName: String, withExtension ext: String = "json") -> Data? {
        if let url = self.url(forResource: fileName, withExtension: ext) {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print("Erro ao carregar o arquivo JSON: \(error)")
            }
        }
        return nil
    }
}
