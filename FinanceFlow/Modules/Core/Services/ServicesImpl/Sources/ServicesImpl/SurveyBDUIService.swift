//
//  SurveyFirebaseService.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.01.2026.
//
import FirebaseServicesAPI
import ServicesAPI
import Foundation
import Domain

public final class SurveyBDUIService: ISurveyBDUIService {

    private let firestoreService: IFirestoreService
    
    public init(firestoreService: IFirestoreService) {
        self.firestoreService = firestoreService
    }

    public func fetchSurvey() async throws -> SurveyPageDTO {
        let data = try await firestoreService.getDocument(path: "surveys/current")
        
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try JSONDecoder().decode(SurveyPageDTO.self, from: jsonData)
    }

    public func send(result: SurveyResult) async throws {
        try await firestoreService.addDocument(collection: "survey_results", data: [
            "surveyId": result.surveyId,
            "deviceId": result.deviceId,
            "rating": result.rating,
            "comment": result.comment ?? "",
            "createdAt": Date()
        ])
    }
}
