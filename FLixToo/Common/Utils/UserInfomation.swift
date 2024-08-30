//
//  UserInfomation.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 30/8/24.
//

import Foundation

struct SaveData: Codable {
    let id: Int?
    let name: String?
    let imagePath: String?
    let type: HomeCategoryOption?
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            
            if let data = UserDefaults.standard.object(forKey: key) as? Data,
               let user = try? JSONDecoder().decode(T.self, from: data) {
                return user
                
            }
            
            return  defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}

struct UserInfomation {
    @UserDefault("first_launch_app", defaultValue: true)
    static var firstLauchApp: Bool
    
    @UserDefault("fav_list", defaultValue: [])
    static var favList: [SaveData]
    
    @UserDefault("watch_later_list", defaultValue: [])
    static var watchLaterList: [SaveData]
    
    @UserDefault("watched_list", defaultValue: [])
    static var watchedList: [SaveData]
    
    @UserDefault("disliked_list", defaultValue: [])
    static var dislikeList: [SaveData]
}
