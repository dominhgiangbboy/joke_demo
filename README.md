### Joke finder

## Intro

- Joke finder is a meme app for finding jokes or puns ...
- Built on Flutter 3.10.6
- Develop time is 3 hours including failed submit time by Do Minh Giang (Joe)

## State management

- In this app I'm using bloc as main state management library.
- I used Bloc instead of Cubit to make the bussiness flow clearer in UI code

## Http client

- **_Dio_** Is my RESTFUL http client of choice because of its ease of use and cover all of possible requirement for this app

## Basic flow of the app

- App only have one screen you can choose categories or blacklist topic you don't want. Search string is there but not required.
- When you have chosen the filter click on _Search jokes_ the app will find a joke for you.
- If there is no joke match your filter a error pop-up says "No matching joke found" will appear
- If the API is returning some weird response or something wrong with the logic the error will be "Error fetching jokes"

## Testing

- Due to limitted time I implemented only unit test and bloc test. Idealy you want to have widget test and integration test also
- Using mockinto to mock some class like http client. Using bloc_test to test bloc funtionality
- Code base is loosely coupled which makes it easier to test
