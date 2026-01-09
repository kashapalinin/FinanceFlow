//
//  SurveyPageDTO.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.01.2026.
//
public struct SurveyPageDTO: Decodable {
    public let id: String
    public let title: String
    public let rating: RatingDTO
    public let comment: CommentDTO
    public let submitButton: ButtonDTO
    
    public init(id: String, title: String, rating: RatingDTO, comment: CommentDTO, submitButton: ButtonDTO) {
        self.id = id
        self.title = title
        self.rating = rating
        self.comment = comment
        self.submitButton = submitButton
    }
}

public struct RatingDTO: Decodable {
    public let maxStars: Int
    
    public init(maxStars: Int) {
        self.maxStars = maxStars
    }
}

public struct CommentDTO: Decodable {
    public let enabled: Bool
    public let placeholder: String
    
    public init(enabled: Bool, placeholder: String) {
        self.enabled = enabled
        self.placeholder = placeholder
    }
}

public struct ButtonDTO: Decodable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

public struct SurveyResult {
    public let surveyId: String
    public let deviceId: String
    public let rating: Int
    public let comment: String?
    
    public init(surveyId: String, deviceId: String, rating: Int, comment: String?) {
        self.surveyId = surveyId
        self.deviceId = deviceId
        self.rating = rating
        self.comment = comment
    }
}
