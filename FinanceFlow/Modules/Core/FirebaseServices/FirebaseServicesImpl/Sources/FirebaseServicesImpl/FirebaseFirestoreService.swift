//
//  FirebaseFirestoreServiceImpl.swift
//  FirebaseServicesImpl
//
//  Created by Павел Калинин on 09.01.2026.
//


import FirebaseFirestore
import FirebaseServicesAPI

public final class FirebaseFirestoreService: IFirestoreService {
    
    private let db = Firestore.firestore()
    
    public init() {}

    public func getDocument(path: String) async throws -> [String : Any] {
        let docRef = db.document(path)
        let snapshot = try await docRef.getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "SurveyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data found"])
        }
        return data
    }
    
    public func setDocument(path: String, data: [String : Any]) async throws {
        let docRef = db.document(path)
        try await docRef.setData(data)
    }
    
    public func addDocument(collection: String, data: [String : Any]) async throws {
        try await db.collection(collection).addDocument(data: data)
    }
}

