//
//  QuoteManager.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/15/24.
//


import Foundation
import FirebaseFirestore
import Combine

struct CategoryData {
    let title: String
    let titles: [String] // Titles to be displayed in the list
    let quotes: [String: [String: String]] // Era -> Title -> [Quote -> Owner]
}

class QuoteManager: ObservableObject {
    static let shared = QuoteManager()
    
    @Published var categories: [String] = []
    @Published var categoryData: [String: [String: [String: String]]] = [:] // Updated to match expected type
    @Published var eras: [String: [String]] = [:] // Eras for each category
    
    private var db = Firestore.firestore()
    
    init() {
        fetchCategories()
    }
    
    func fetchCategories() {
        db.collection("Quotes").document("Categories").collection("Categories").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No categories found")
                return
            }
            
            let fetchedCategories = documents.compactMap { $0.documentID }
            DispatchQueue.main.async {
                self?.categories = fetchedCategories
                self?.fetchAllCategoryData()
            }
        }
    }
    
    private func fetchAllCategoryData() {
        for category in categories {
            fetchEras(for: category)
        }
    }
    
    func fetchEras(for category: String) {
        db.collection("Quotes").document("Categories").collection("Categories").document(category).collection("Eras").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error fetching eras for \(category): \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No eras found for \(category)")
                return
            }
            
            let fetchedEras = documents.compactMap { $0.documentID }
            DispatchQueue.main.async {
                self?.eras[category] = fetchedEras
                self?.fetchCategoryData(for: category, eras: fetchedEras)
            }
        }
    }
    
    private func fetchCategoryData(for category: String, eras: [String]) {
        for era in eras {
            fetchQuotes(for: category, era: era) { [weak self] quotes in
                DispatchQueue.main.async {
                    if self?.categoryData[category] == nil {
                        self?.categoryData[category] = [:]
                    }
                    self?.categoryData[category]?[era] = quotes
                }
            }
        }
    }
    func fetchQuotes(for category: String, era: String, completion: @escaping ([String: String]) -> Void) {
        db.collection("Quotes").document("Categories").collection("Categories").document(category).collection("Eras").document(era).getDocument { document, error in
            if let error = error {
                print("Error fetching quotes for \(category) - \(era): \(error)")
                completion([:])
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("No data found for \(category) - \(era)")
                completion([:])
                return
            }
            
            var quotes: [String: String] = [:]
            
            for (title, ownerQuotes) in data {
                if let ownerQuotesDict = ownerQuotes as? [String: String] {
                    for (owner, quote) in ownerQuotesDict {
                        quotes[quote] = "\(title) - (\(owner))"
                    }
                }
            }
            
            print("Processed quotes for \(category) - \(era): \(quotes)")
            completion(quotes)
        }
    }
}
