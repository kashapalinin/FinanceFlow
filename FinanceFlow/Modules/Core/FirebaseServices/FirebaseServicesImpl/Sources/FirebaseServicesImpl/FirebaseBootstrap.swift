//
//  FirebaseBootstrap.swift
//  FirebaseServicesImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import FirebaseCore

public final class FirebaseBootstrap {
    public static func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}
