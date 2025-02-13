//
//  ViewController.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//
import UIKit
import Network

class ViewController: UIViewController {
    
    private let requestManager = RequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAPOD()
    }
    
    private func fetchAPOD() {
        Task {
            do {
                let response: APODResponse = try await requestManager.request(
                    endpoint: APIEndpoint.apodByDate(date: "2025-02-10")
                )
                print(response)

            } catch let error as RequestError {
                print("🚨 Erro na API: \(error.errorMessage)")
            } catch {
                print("🚨 Erro inesperado: \(error.localizedDescription)")
            }
        }
    }
}



