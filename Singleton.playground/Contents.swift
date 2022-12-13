import UIKit

//Данная программа создаёт специальный хранитель для логина и пароля, который и является singleton'ом.
class LoginPasswordHolder{
    //Словарь pair содержит в себе логин и пароль.
    private var pair: [String: String] = [:]
    //Инициализатор объявлен частным, чтобы его невозможно было вызвать извне и создать новый экземпляр
    private init(){}
    
    //Данная переменная вызывается вместо инициализатора и содержит экземпляр класса, созданнный один раз. По сути, благодаря этому класс LoginPasswordHolder и является singleton'ом.
    static var shared: LoginPasswordHolder = {
            let instance = LoginPasswordHolder()
            return instance
    }()
    
    //Если экземпляр нашего класса пока не содержит логин и пароль, то эта функция устанавливает их.
    func setLoginPassword(_ l: String, _ p: String){
        if LoginPasswordHolder.shared.pair.isEmpty{
            LoginPasswordHolder.shared.pair[l] = p
            print("The user set up login "+l+" and created a password "+p)
        } else {
            print("Login and password have already been set up.")
        }
    }
    
    //Проверяет, соответствуют ли введённые пользователем логин и пароль тем, которые хранятся в singleton'е.
    public func checkLoginPassword(login: String, password: String){
        if LoginPasswordHolder.shared.pair.keys.contains(login) && LoginPasswordHolder.shared.pair.values.contains(password){
            print("Authentification successful. Access granted")
        } else {
            print("Login or password is incorrect. Please try again")
        }
    }
}
extension LoginPasswordHolder: NSCopying {
    //Единственный экземпляр класса LoginPasswordHolder не может быть клонирован, поэтому данная функция при "клонировании" этого экземпляра возвращает оригинал.
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

//Клиентский код
class ClientCode{
    func checkLoginPasswordHolder(){
        let oneInstance = LoginPasswordHolder.shared
        let anotherInstance = LoginPasswordHolder.shared
        //Проверка, являются ли два экземпляра класса LoginPasswordHolder идентичными.
        if (oneInstance === anotherInstance){
            print("There is only one instance of our singleton")
            oneInstance.setLoginPassword("Igor_101", "qwerty124")
            anotherInstance.checkLoginPassword(login: "Igor_101", password: "qwerty124")
            anotherInstance.checkLoginPassword(login: "Igor_101", password: "qwerty125")
        } else {
            print("Something's wrong")
        }
    }
}
let client = ClientCode()
client.checkLoginPasswordHolder()
