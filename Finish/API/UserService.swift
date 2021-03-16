//
//  UserService.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
    }
}
