# Pager

Implementation of Aircall's [technical-test-pager](https://github.com/aircall/technical-test-pager).

## Installation 

Install pager with bundle

```bash 
  bundle
```
    
## Running Tests

To run tests, run the following command:

```bash
  rspec --format documentation
```

  
## Documentation

While I was implementing the `PagerService` domain logic, it made me think of 
the Observer pattern:
- there are different services which "watch" the `PagerService` and act when they are notified: `SmsService`, `MailService`, `TimerService`
- the `PagerService` also "watch" other services / app and act when they notify him: `AlertingService`, `PageWebConsole`, `TimerService`

It also made me think of the Mediator Pattern, as the `PagerService` forbid Services to know 
how other Services are implemented and make the orchestration between them.

These principles guided me while I implemented the domain logic.

#### Interfaces

I implemented the same interface with a method `notify` to `SmsService` and `MailService` as they act with the same kind of data (they need a way of contact and a message). 

`TimerService` did not feel the same, as it "talks back" to the `PagerService` and notify when it's done, so it has its own `set` method instead of notify.

`EscalationPolicyService` is also special as it returns data and didn't feel like it should respond to the same `notify` method.

#### Dispatcher

I noticed that in the `Dispatcher` I have three methods which 
are quite look alike `alert_update`, `acknowledgement_timeout_update`, `acknowledgement_update`. 

If I had more time, I think I'd try to maybe make it more modular, maybe with only one update method which takes in an object of the services it's called from and respond according to the object. 

It felt easier to start with a more "procedural" way of dealing with the `Dispatcher` and more readable.

## DB

I'd implement a relational database.


