import UIKit
import XCTest

//Протокол для Наблюдателя
protocol NewsAppObserver: class {
    //Функция получения уведомлений
    func receiveNotification(newsApp: NewsApp, title: String)
    func setFavouriteTopic()->NewsTopics
}

class NewsApp{
    //булевая переменная, хранящая состояние объекта
    var newArticleIsPublished = false
    private var economicsObservers: [NewsAppObserver] = []
    private var politicsObservers: [NewsAppObserver] = []
    private var cultureObservers: [NewsAppObserver] = []
    private var articlesDict: [String: String] = [:]
    
    //Функция добавления Наблюдателя
    func addObserver(observer: NewsAppObserver, topic: NewsTopics) {
        switch topic {
        case .economics:
            economicsObservers.append(observer)
        case .politics:
            politicsObservers.append(observer)
        case .culture:
            cultureObservers.append(observer)
        }
    }
    
    //Функция удаления Наблюдателя
    func deleteObserver(observer: NewsAppObserver, topic: NewsTopics){
        switch topic {
        case .economics:
            if let idx = economicsObservers.firstIndex(where: {$0 === observer}) {
                economicsObservers.remove(at: idx)
            }
        case .politics:
            if let idx = politicsObservers.firstIndex(where: {$0 === observer}) {
                politicsObservers.remove(at: idx)
            }
        case .culture:
            if let idx = cultureObservers.firstIndex(where: {$0 === observer}) {
                cultureObservers.remove(at: idx)
            }
        }
    }
    
    //Функция уведомления
    func notifyObservers(topic: NewsTopics, title: String){
        switch topic {
        case .economics:
            economicsObservers.forEach({$0.receiveNotification(newsApp: self, title: title)})
        case .politics:
            politicsObservers.forEach({$0.receiveNotification(newsApp: self, title: title)})
        case .culture:
            cultureObservers.forEach({$0.receiveNotification(newsApp: self, title: title)})
        }
    }
    
    func publishNewArticle(topic: NewsTopics, title: String, content: String){
        newArticleIsPublished.toggle()
        articlesDict[title] = content
        notifyObservers(topic: topic, title: title)
        newArticleIsPublished.toggle()
    }
}

//Перечисление, описывающее тематики по которым могут быть написаны статьи. Также у каждого Наблюдателя есть любимая тема, поэтому Наблюдатели делятся в зависимости от тематики и получают уведомления о новых статьях по их любимой теме
enum NewsTopics {
    case economics
    case politics
    case culture
}

//Конкретные имплементации протокола Наблюдателя в зависимости от выбранной темы
class EconomicsObserver: NewsAppObserver{
    func setFavouriteTopic() -> NewsTopics {
        return NewsTopics.economics
    }
    func receiveNotification(newsApp: NewsApp, title: String) {
        if newsApp.newArticleIsPublished{
            print("A new article about the world of politics titled "+title+" has just been published")
        }
    }
}

class PoliticsObserver: NewsAppObserver{
    func setFavouriteTopic() -> NewsTopics {
        return NewsTopics.politics
    }
    func receiveNotification(newsApp: NewsApp, title: String) {
        if newsApp.newArticleIsPublished{
            print("A new article describing the economics titled "+title+" has just been published")
        }
    }
}

class CultureObserver: NewsAppObserver{
    func setFavouriteTopic() -> NewsTopics {
        return NewsTopics.culture
    }
    func receiveNotification(newsApp: NewsApp, title: String) {
        if newsApp.newArticleIsPublished{
            print("A new article about cultural aspects of our world titled "+title+" has just been published")
        }
    }
}

//Тестирование
class ObserverTest{
    func testObserver(){
        let newsApp = NewsApp()
        let economicObserver = EconomicsObserver()
        let politicsObserver1 = PoliticsObserver()
        let cultureObserver = CultureObserver()
        let cultureObserver2 = CultureObserver()
        let array: [NewsAppObserver] = [economicObserver, politicsObserver1, cultureObserver, cultureObserver2]
        for observer in array{
            newsApp.addObserver(observer: observer, topic: observer.setFavouriteTopic())
        }
        newsApp.publishNewArticle(topic: .culture, title: "Lorem ipsum dolor", content: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
        newsApp.deleteObserver(observer: cultureObserver2, topic: cultureObserver2.setFavouriteTopic())
        newsApp.publishNewArticle(topic: .culture, title: "Foo baz bar", content: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}

let test = ObserverTest()
test.testObserver()
