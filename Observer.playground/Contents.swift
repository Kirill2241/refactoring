import UIKit
import XCTest
import Foundation
import Combine

class NewsApp: NSObject{
    //наблюдатели, приписанные к этому объекту
    private var observers: [NewsAppObserver] = []
    var articlesArray: [String] = []
    //Кол-во элементов в массиве возьмём за состояние объекта. Поскольку изначально массив пустой, число равно 0
    @objc dynamic var numberOfArticles: Int = 0
    
    //Функция добавления Наблюдателя
    func addObserver(observer: NewsAppObserver) {
        observers.append(observer)
    }
    
    //Функция удаления Наблюдателя
    func deleteObserver(observer: NewsAppObserver){
        if let idx = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: idx)
        }
    }
    
    func publishNewArticle(title: String){
        articlesArray.append(title)
        //меняется состояние объекта
        numberOfArticles += 1
    }
}

//Протокол для Наблюдателя
protocol NewsAppObserver: class, NSObject {
    //Функция получения уведомлений
    func receiveNotification(title: String)
    init(app: NewsApp)
}

//Конкретная имплементация протокола Наблюдателя
class Observer: NSObject, NewsAppObserver{
    @objc var newsApp: NewsApp
    //Создание KVO с помощью Combine
    var observation: NSKeyValueObservation?
    
    required init(app: NewsApp) {
        self.newsApp = app
        super.init()
        observation = observe(\.newsApp.numberOfArticles,options: [.old, .new]){ object, change in
            self.receiveNotification(title: self.newsApp.articlesArray[(change.newValue!-1)])
        }
    }
    
    func receiveNotification(title: String) {
        print("A new article has been published! It's title is "+title)
    }
}


//Тестирование
class ObserverTest{
    func testObserver(){
        let newsApp = NewsApp()
        let oneObserver = Observer(app: newsApp)
        let anotherObserver = Observer(app: newsApp)
        newsApp.addObserver(observer: oneObserver)
        newsApp.addObserver(observer: anotherObserver)
        newsApp.publishNewArticle(title: "Lorem ipsum dolor")
        newsApp.publishNewArticle(title: "Foo baz bar")
    }
}

let test = ObserverTest()
test.testObserver()
