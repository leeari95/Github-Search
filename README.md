# GitHub Search App 프로젝트

* 개인 프로젝트
* 프로젝트 기간: 2022.05.04 - 2022.05.14

# 목차

- [키워드](#키워드)
- [프로젝트 소개](#%EF%B8%8F-프로젝트-소개)
- [프로젝트 주요기능](#-프로젝트-주요기능)
- [기술적 도전](#-기술적-도전)
- [Trouble Shooting](#-trouble-shooting)
    + [중복된 식별자 오류](#중복된-식별자-오류)
    + [잘못된 쿼리 에러](#잘못된-쿼리-에러)
    + [SearchBar가 통통 튀는 현상](#searchbar가-통통-튀는-현상)
- [새롭게 알게된 것](#-새롭게-알게된-것)
    + [앱을 전역적으로 세팅하는 방법](#앱을-전역적으로-세팅하는-방법)
    + [디코딩 에러가 났을 때, 상세한 에러메세지를 확인하기](#디코딩-에러가-났을-때-상세한-에러메세지를-확인하기)
    + [로그인 이벤트를 어떻게 전달해줄까?](#로그인-이벤트를-어떻게-전달해줄까)

## 키워드

* `Architecture` / `Design Pattern`
    * `Clean Architecture MVVM`
    * `Coordinator`
    * `Delegate`
    * `Event Listeners`
* `UIKit`
    * `UICollectionViewDiffableDataSource`
    * `UIGestureRecognizer`
    * `Appearance`
* `GitHub Rest API`
* `OAuth 2.0`
* `Keychain`
* `NSCache`

</br>

## ⭐️ 프로젝트 소개

Github Rest API를 활용한 앱이에요.

다른 사람의 레파지토리를 검색할 수 있는 기능이 있어요.

별표 표시를 터치하여 체크/해제를 할 수 있어요.

로그인을 하면, 자신의 프로필 및 레파지토리를 불러올 수 있어요.

</br>

## ✨ 프로젝트 주요기능

> 🔍 검색창에서 원하는 레파지토리를 검색해볼 수 있어요.

<img src="https://i.imgur.com/Ck7scIG.gif" width=30%>

# 

> ⛔️ 로그인 상태가 아니라면 별표 표시를 체크/해제 할 수 없어서, 로그인 화면으로 이동하게 됩니다.

<img src="https://i.imgur.com/Sf53TJF.gif" width=30%>

#

> 👤 로그인 시 프로필 및 자신의 레파지토리 목록을 가져옵니다.

<img src="https://i.imgur.com/HGwaUxB.gif" width=30%> <img src="https://i.imgur.com/d2h1mN8.gif" width=30%>

#

> ⭐️ 로그인/로그아웃 시 자신의 기존 별표 목록과 동기화 됩니다.

<img src="https://i.imgur.com/5H9bfr2.gif" width=30%>

#

> ✅ 별표 체크 시 두 화면 모두 동기화 됩니다.

<img src="https://i.imgur.com/L6tr4fO.gif" width=30%>

#

> 👆🏻 일정 길이 이상 스크롤 시 다음 페이지를 Prefetch 합니다.

<img src="https://i.imgur.com/cTgLTK8.gif" width=30%>

</br>

## 💪🏻 기술적 도전

### MVVM

* 뷰컨트롤러와 뷰는 화면을 그리는 역할에만 집중시키고 데이터 관리와 비즈니스 로직은 뷰모델에서 진행되도록 구성하였습니다.

### Clean Architecture

* 뷰모델의 비즈니스 로직들을 유즈케이스로, 네트워크에 대한 요청은 repository로 분리해 각 레이어의 역할을 분명하게 나누었습니다.

### Coordinator 패턴 사용

* 화면 전환에 대한 로직을 ViewController로부터 분리하고 의존성 객체에 대한 주입을 외부에서 처리하도록 하기 위해서 코디네이터 패턴을 사용하게 되었습니다.

</br>

## 🛠 Trouble Shooting

### 중복된 식별자 오류

```
Thread 7: "Fatal: supplied item identifiers are not unique. Duplicate identifiers:

*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Fatal: supplied item identifiers are not unique. Duplicate identifiers: {(
    GithubSearchApp.RepositoryItem(id: 190487472, name: "animal-crossing-music-sim", login: "owendaprile", description: "Animal Crossing Music Simulator", isMarkedStar: false, starredCount: 2),
    GithubSearchApp.RepositoryItem(id: 256757675, name: "Animal-Crossing-App", login: "carluqcor", description: "", isMarkedStar: false, starredCount: 2)
)}'
```
* `상황` diffable datasource로 컬렉션뷰를 완성하고, 스크롤 하는 도중 위와 같은 에러가 발생했다.
* `이유` 셀의 식별자가 고유하지 않다는 에러였다. 셀의 정보를 담고있는 RepositoryItem 타입이 단순히 Hashable을 준수하고는 있지만, 동일한 정보를 가질 수 있으며, 이 상황에서 오류가 발생하는 것이였다.
* `해결` 받아오는 값중 고유하다고 생각되는 데이터를 해싱하도록 hash(into:) 메소드를 재정의 해주었다.

```swift
extension RepositoryItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(login)
        hasher.combine(description)
    }
    static func ==(lhs: RepositoryItem, rhs: RepositoryItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.login == rhs.description
     }
}
```

#

### 잘못된 쿼리 에러

```
 '*** +[NSURLComponents setPercentEncodedQueryItems:]: invalid characters in percentEncodedQueryItems'
```
* `상황` 쿼리를 활용하여 검색을 시도하다가 위와 같은 에러가 발생했다.
* `이유` URL을 인코딩 할때, 검색키워드 중 띄어쓰기(공백)는 URL로 인식할 수 있는 언어가 아니기 때문에 나는 에러였다.
* `해결` 따라서 URL을 반환하기 전에 쿼리를 인코딩해주는 작업을 추가해주니 해결되었다.

```swift
 var url: URL? {
    guard let url = self.baseURL?.appendingPathComponent(self.path) else {
        return nil
    }
    var urlComponents = URLComponents(string: url.absoluteString)
    let urlQuries = self.parameters.map { key, value -> URLQueryItem in
        let value = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // 인코딩 작업을 추가해주니 해결되었다.
        return URLQueryItem(name: key, value: value)
    }

    urlComponents?.percentEncodedQueryItems = urlQuries

    return urlComponents?.url
}
```

#

### SearchBar가 통통 튀는 현상

![](https://i.imgur.com/reKZ1wA.gif)

* `상황` 서치바를 클릭할 때 마다 검색바가 비정상적으로 통통 튀는 현상이 나타났다.
* `시도` searchController의 hidesNavigationBarDuringPresentation 속성을 false로 줘보았는데 해결되지 않았다.
* `해결` 뭔가 여러 상황에서 서치바를 클릭할 때마다 컬렉션뷰의 셀들이 자연스러운 느낌이 아닌 미리 자리를 잡는 느낌이라서, ViewController 속성 중 edgesForExtendedLayout의 값을 .bottom으로 할당해주었더니 해당 현상이 해결되었다.
    * 이렇게 하게되면 네비게이션 바가 있는 영역에는 콘텐츠가 자리잡지 않는다.

</br>

## 🔥 새롭게 알게된 것

### 앱을 전역적으로 세팅하는 방법

* tintColor나, appearance 관련된 속성값들을 모든 뷰 컨트롤러가 동일하게 가져갔으면 해서 찾아보았다.
* 먼저 AppAppearance이라는 클래스 타입을 선언해준다.

```swift
final class AppAppearance {
    static func setUpAppearance() {
        UITabBar.appearance().tintColor = .label
        UIBarButtonItem.appearance().tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
```

* 그리고 AppDelegate에서 전역적으로 세팅할 수 있도록 호출해준다.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppAppearance.setUpAppearance() // 호출
        return true
    }
```

#

### 디코딩 에러가 났을 때, 상세한 에러메세지를 확인하기

* DTO 타입 문제로 디코딩 실패가 되는데, 에러메세지가 따로 뜨지 않아서 원인을 찾는게 어렵던 와중에 찾은 방법이다.

```swift
do {
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Root].self, from: data!)
} catch {
    // print(localizedDescription) // <- ⚠️ Don't use this!

    print(String(describing: error)) // <- ✅ Use this for debuging!
}
```

* 보통 error의 `localizedDescription`을 통해 에러메세지를 확인해보려고 하는데, 디코딩 에러의 경우 `String(describing:)` 이니셜라이저를 사용하여 에러메세지를 디버깅해볼 수 있었다.

#

### 로그인 이벤트를 어떻게 전달해줄까?

* 로그인을 했을 때, 로그아웃을 했을 때 뷰가 보여주는 데이터를 다르게 표시하도록 해야하는데, 어떤 방법이 있나 찾아보다가 해당 글을 보게 되었다.
    * https://betterprogramming.pub/event-listeners-on-swift-867a239bb23b
* 방식은 리스너라는 프로토콜을 만들고, 로그인했거나 로그아웃 했을 때 실행할 메소드를 정의해준다.
* 그리고 로그인/로그아웃 이벤트가 발생할 때마다 일을 해야하는 객체들에게 리스너를 준수하도록 하게하고, 로그인 매니저를 활용해 이벤트가 발생할 때마다 리스너들이 일처리를 할 수 있도록 구성해주었다.
* 나의 경우는 Storage > Repository > UseCase 순서대로 데이터를 네트워크로 불러오는 시점을 정확히 파악할 수가 없어서 옵저버를 활용하여 다음 리스너가 일처리를 할 수 있도록 구성해주었다.

```swift
final class LoginManager {
    static let shared = LoginManager()
    private init() {}
    
    private let apiRequest: APIProvider = DefaultAPIProvider()
    var isLogged: Bool {
        KeychainStorage.shard.load("Token") == nil ? false : true
    }
    // 리스너들을 담아두는 배열
    private var listeners: [WeakReference<AuthChangeListener>] = []
    
    // 리스너 등록
    func addListener(_ listener: AuthChangeListener) {
        if listeners.compactMap({ $0.value?.instanceName() }).contains(listener.instanceName()) {
            return
        }
        listeners.append(WeakReference(value: listener))
    }
    
    func authorize() {
        guard let url = APIAddress.code(clientID: Secrets.clinetID, scope: "repo,user").url else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func requestToken(code: String, completion: ((Result<Bool, Error>) -> Void)?) {
        guard let url = APIAddress.token(clientID: Secrets.clinetID, clientSecret: Secrets.clinetSecret, code: code).url else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        apiRequest.execute(request: request) { result in
            switch result {
            case .success(let data):
                data.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: String] }
                .flatMap { $0["access_token"] }
                .flatMap {
                    if KeychainStorage.shard.save(key: "Token", value: $0) {
                        print("사용자의 토큰을 키체인에 저장하는데 성공했습니다!")
                        // 첫번재 리스너가 이벤트를 받아 일처리를 하도록 메소드 호출
                        self.listeners.first?.value?.authStateDidChange(isLogged: true)
                        completion?(.success(true))
                    } else {
                        print("토큰을 가져오지 못했습니다.")
                        completion?(.success(false))
                    }
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func logout() {
        KeychainStorage.shard.delete(key: "Token")
        listeners.forEach {
            $0.value?.authStateDidChange(isLogged: false)
        }
    }
    
    // 첫번재 리스너가 일을 모두 마치면 이 메소드를 활용하여 다음 리스너가 일처리를 할 수 있도록 한다.
    func executeNextWork(_ order: String, isLogged: Bool = LoginManager.shared.isLogged) {
        guard let index = listeners.compactMap({ $0.value?.instanceName() }).firstIndex(of: order) else {
            return
        }
        listeners[index].value?.authStateDidChange(isLogged: isLogged)
    }
}
```

* 그리고 추후 메모리 누수를 방지하기 위해 WeakReference라는 클래스를 만들어 리스너들을 담아주었다.

#

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#github-search-app-프로젝트)
