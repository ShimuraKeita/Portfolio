//
//  ActionSheetLauncher.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/17.
//

import UIKit

class ActionSheetLauncher: NSObject {
    
    //MARK: - Properties
    
    private let user: User
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    //MARK: - Helpers
    
    func show() {
        print(user.username)
    }
}
