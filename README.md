# Teambuilder
A place where developers can find others like them and build stuff together... sort of.

## Getting Started
There's no special requirements to work on this project besides having the fully functional [Flutter SDK](https://flutter.dev/docs/get-started/install), cloning this repo and then run `flutter install teambuilder`.

Confused? Just follow these easy steps (make sure you have git installed on your [Windows PC](https://gitforwindows.org/) or [Linux/Mac (just do brew install git)](https://brew.sh/) and also the Flutter SDK):

1. Read the Update section of this Repo.
2. `git clone git@github.com:vladventura/teambuilder`
3. `cd teambuilder`
4. `flutter pub get .`
5. After reading the Update section of this repo, you can finally run `flutter run -flavor dev -d $DEVICE_NAME` on the root of your clone 

Voila. You're all set to contribute to this project. Thank you!

## Update
As of 12/20/2019 I won't serve the google-services.json file (needed to use the Firebase service) because we're now using 2 of these, one for Production and another one for Development, and these contain sensitive information. So, until I can get Travis CI running, there's no google-services.json files here :(. I'm sorry but I just wanna be safe.

However! If you do opt to contribute regardless of this obstacle, I really appreciate it! You can forge your own google-services.json through a Firebase project, and then copy and paste it to `./android/app/src/dev/` (create this directory if it's not already there; also create another one called prod, this one can be empty but it must be there). Lastly, whenever you run your copy of the App, use `flutter run --flavor dev -d $DEVICE_NAME` or `flutter run --flavor prod -d $DEVICE_NAME` if you copied the json file to the prod directory, or you have two json files.

Thank you so much!
