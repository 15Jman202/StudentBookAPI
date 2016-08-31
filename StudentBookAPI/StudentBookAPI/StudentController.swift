//
//  StudentController.swift
//  StudentBookAPI
//
//  Created by Justin Carver on 8/31/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation

class StudentController {
    
    static let baseURL = NSURL(string: "https://studentpostapi.firebaseio.com/students")
    static let getterEndPoint = baseURL?.URLByAppendingPathExtension("json")
    
    static func sendStudent(name: String, completion: ((success: Bool) -> Void)? = nil) {
        
        let student = Student(name: name)
        
        guard let url = baseURL?.URLByAppendingPathComponent(name).URLByAppendingPathExtension("json") else {
            completion?(success: false)
            return
        }
        
        NetworkController.performRequestForURL(url, httpMethod: .Put, urlParameters: nil, body: student.jsonData) { (data, error) in
            
            var success = false
            
            defer {
                completion?(success: success)
            }
            
            guard let data = data,
                reponseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                return
            }
            
            if error != nil {
                print("error: \(error?.localizedDescription)")
            } else if reponseDataString.containsString("error") {
                print("Error: \(reponseDataString)")
            } else {
                print("Successfully saved data to endpoint. \nReponse: \(reponseDataString)")
                success = true
            }
        }
    }
    
    
    static func fetchStudents(completion: (students: [Student]) -> Void) {
        guard let url = getterEndPoint else {
            completion(students: [])
            return }
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            guard let data = data else {
                completion(students: [])
                return }
            
            guard let StudentDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String:AnyObject]] else {
                completion(students: [])
                return }
            
            let students = StudentDictionary.flatMap({Student(dictionary: $0.1)})
            completion(students: students)
        }
    }
}