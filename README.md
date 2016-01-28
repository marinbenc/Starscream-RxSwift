# Starscream-RxSwift
A simple and lightweight extension to Starscream to track suscribe to socket events with RxSwift

## Features
* `rx_response`: emits SocketEvents (an enum) with the text or data recieved by the socket, and errors on disconnect
* `rx_text`: emits strings recieved from the socket, and an error on disconnect
* `rx_data`: emits data recieved from the socket, and an error on disconnect

## Usage examples

```Swift
let events = socket?.rx_response()
  .subscribe { event in
    switch event {
      case .Error(let error): print(error)
      case .Next(let socketEvent):
        switch socketEvent {
          case .Connected: print("Chat connected")
          case .Message(let text): chat.showMessage(text)
          case .Data(let data): chat.showImageFromData(data)
        }
    }
  }
```

```Swift
let messages = self.socket.rx_text()
  //transform the string we got into some sort of chat message we can use
  .flatMapLatest { jsonText -> Observable<ChatMessage> in
    if  let message = JSONParser.getChatMessageFromString(jsonText) {
      return Observable.just(message)
    } else {
      return Observable.empty()
    }
  }
  //display the parsed message
  .subscribeNext { message in
    chat.showMessage(message)
  }
  .addDisposableTo(disposeBag)
```
