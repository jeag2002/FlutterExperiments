# Discover your own adventure

hackaton first example project.

![alt text](https://github.com/jeag2002/FlutterExperiments/blob/master/hackaton_project/hackaton_project.jpg?raw=true)

Complete execution [here](https://youtu.be/7CPZFWzqqBI)

(tested as native windows application and browser application; chrome/edge)

## Technologies used:

- Microsoft Windows 10 Professional Edition x64
- Flutter 3.3.0
- Google IA Gemini 1.0 (through Google Cloud)
- SQLite 2.3.2

## Presentation: 

Can been seen [here](ppt/Your_Story_v1.ppt)

## Definition:

All the parameters and constants are defined here [my_config.json](assets/properties/my_config.json)

|parameter|description|value|
|---------|-----------|-----|
|url|google cloud gemini project. Explanation how create a google cloud gemini project [here](https://cloud.google.com/gemini/docs/discover/set-up-gemini)|<google cloud gemini api>|
|api-key|access-token for your google cloud gemini engine. Explanation how to create this api key [here](https://saturncloud.io/blog/how-to-get-an-access-token-from-google-cloud/)|<your gemini api access-token key>|
|first-message|query for gemini engine. Creating a beginning of the story|Generate a %s story with %s as protagonist. Stop on one point and create Option One: and Option Two: to continue the story|
|next-message|query for gemini engine. Create a step of the story|Option %s chosen. Show the option chosen, continue with the story until stop on one point and create Option One: and Option Two: to continue the story|
|final-message|query for gemeni engine. Create a final of the story|Create a final for this story|
|username-email|user gmail account where we want to send the story|*****@gmail.com|
|password-email|app password used by the flutter engine for access to the smtp server of gmail. Can be configured in this [way](https://support.google.com/accounts/answer/185833?hl=en)|<password>|

## Execution:

- Go to project baseline and execute "flutter run"
- Go to build/windows/x64/runner/Debug/ and run "hackaton_project.exe"
