# Project 2 - FlixApp

FlixApp is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User sees an app icon on the home screen and a styled launch screen.
- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.
- [X] User sees an error message when there's a networking error.
- [X] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [X] User can tap a poster in the collection view to see a detail screen of that movie
- [X] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [X] Users can pull to refresh in grid view
- [X] Users can watch the trailer for a movie from the description view


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. UI design techniques - how to make something look pretty with little tweaks and changes
2. Color theory - what color combinations would look good for an application

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/QvNTlY2OoF.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='http://g.recordit.co/BdeH44VDNh.gif' title='Refresh and Networking Error Walkthrough' width='' alt='Refresh and Networking Error Walkthrough' />

GIF created with [Recordit](https://recordit.co/).

## Notes

Describe any challenges encountered while building the app.

SVProgressHUD - could not find window in AppDelegate, had to make window public in header of AppDelegate and add another line in SceneDelegate.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) - clean and easy-to-use HUD meant to display the progress of an ongoing task on iOS and tvOS

## License

    Copyright 2020 Monica Bui

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
