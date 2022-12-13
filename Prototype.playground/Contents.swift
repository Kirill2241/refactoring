import UIKit
import XCTest

//Программа стимулирует работу небольшой социальной сети, в которой есть пользователи, есть группы, состоящие из пользователей, а у каждого пользователя есть посты на стене.

private class Group{
    private var id: Int
    private var title: String
    private var members = [SocialNetworkUser]()
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    //Добавление нового пользователя в группу
    func addMember(member: SocialNetworkUser) {
        members.append(member)
    }
    
    //Число всех пользователей в группе.
    var membersCount: Int {
        return members.count
    }
}

//Класс отдельного пользователя.
private class SocialNetworkUser: NSCopying{
    //Свойства класса: id, имя, группа и список постов
    private(set) var userID: Int
    private(set) var username: String
    private weak var userGroup: Group?
    private(set) var posts = [SocialNetworkPost]()
    
    //Инициализация
    init(userId: Int, username: String, userGroup: Group?) {
        self.userID = userId
        self.username = username
        self.userGroup = userGroup
        userGroup?.addMember(member: self)
    }
    
    //Добавление постов
    func addPost(post: SocialNetworkPost){
        posts.append(post)
    }
    
    //Функция "копирует" пользователя на основе свойств оригинала.
    func copy(with zone: NSZone? = nil) -> Any {
        return SocialNetworkUser(userId: userID, username: "Копия "+username, userGroup: userGroup)
    }
}

private struct SocialNetworkPost{
    let date = Date()
    let content: String
}
class PrototypeTest: XCTestCase{
    
    func testPrototype(){
        let group = Group(id: 108, title: "Officio")
        let user = SocialNetworkUser(userId: 117, username: "Ivan Van", userGroup: group)
        user.addPost(post: SocialNetworkPost(content: "hi"))
        
        guard let anotherUser = user.copy() as? SocialNetworkUser else {
                XCTFail("User was not copied")
                return
            }
        
        //При инициализации класса пользователя массив с постами пустой, поэтому у копии он должен быть пустым.
        XCTAssert(anotherUser.posts.isEmpty)
        XCTAssert(group.membersCount == 2)
        print("Original username: "+user.username)
        print("Username of copy: "+anotherUser.username)
        print("Number of members: \(group.membersCount)")
    }
}
let testObject = PrototypeTest()
testObject.testPrototype()
