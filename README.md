
### Moneybox iOS Technical Challenge
 
# My Approach - Design 

### Keeping the concept of the prototypes
My approach from a design perspective was to build the app in a way that represented the prototype wireframes as much as possible whilst also adding in some additions from my side either to bolster the initial design or simply to provide more information to the user/customer

Taking login as an example; whilst maintaining the intended layout and structure of the original wireframe I've added in a few additional UI elements along with a number of custom animations to give the app a nice feel to it
<img src="https://github.com/tidalboot/iOS-Tech-Task/assets/4403178/bcb54677-d167-4879-a496-13967b6f6d6b" width=450>

-------
### Consistency in the scheme
Consistency is incredibly important in the design of an app and so the app makes use of 6 custom Color sets all designed with both dark and light mode in mind to prevent any screens from feeling "disconnected" from one another

-------
### Appropriate haptics and feedback
Timely use of haptics is, in my opinion, often underrated and for the effort of introducing even basic feedback they often feel like an easy way to bring the perceived feel of an app up a few notches. 

Whilst you won't be able to try them out on a simulator unfortunately (Definitely feel free to try it out on your own device if you want to try them out) I've added a number of haptics both via `UINotificationFeedbackGenerator` and `UIImpactFeedbackGenerator` where appropriate throughout the app.

-------

# My Approach - Architecture 

### Keeping it simple
The project has been designed in a "soft" MVVM approach in that there are clear `Views` and `ViewModels` but, for now, the `Models` are small and limited in scope due to the lack of any complex models required. 

You can best see this in the `AccountsViewController` -> `AccountViewModel` and `AccountInformation` set up for the Accounts screen. Whilst `AccountInformation` isn't named something like `AccountInformationModel` it currently acts as the seperate `Model` in this situation. Whilst the lack of model complexity meant that the proxy model objects are small in the current project they have still be separated to allow for easy expansion in the future should the need arise. 

-------
### Handling network calls
In order to provide an easy way for the different `ViewModels` to reach out to the server in a consistent way I created a shared `SessionHandler` which keeps private references to the necessary `DataProvider` objects along with information around the current user, the session token expiration time and a stored login request for login retries when our session expires

Whilst the user is "persisted" whilst within the app persistence has been intentionally left out between instances of the app. 

-------
### Handling session expiration
The shared `SessionHandler` both keeps track of when the session has expired through the `tokenHasExpired()` and subsequently the `hasFiveMinutesPassedSinceDate` functions. 

With this in mind I've implemented a very basic but useful `checkTokenFreshness` passthrough function which, given an expired token, will first refresh the current login session before then continuing on with the request that was made. This function is referenced in both `loadAccounts` and `topUpAccount` meaning none of the `Views` or UI handlers need to know anything about the guts of the token handling. 

-------

## Notes
I've left the login actually pointing at the sandbox environment so it will stick work with the test user you provided (I'll pop it here just so you have an easy reference to it)
|  Username          | Password         |
| ------------- | ------------- |
| test+ios2@moneyboxapp.com  | P455word12  |

Alternatively if you want to make logging in easier for testing you can simply toggle the `testing` property within `SessionManager` to log in with the above test account no matter what you enter in the email or password fields. 

-------


Looking foward to getting your thoughts on the task and of course if you have questions feel free to reach out!

