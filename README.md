# Minimal

Minimal is a Rainmeter Skin, which can be found [here](http://rainmeter.net/cms/). It offers minimalistic tools for your desktop work and fun, for example Media Player, FeedReader and display of statistics of your CPU, RAM, Volume, etc

It requires the most current version of Rainmeter to work. 

![Screenshot](http://puu.sh/44cJZ.png)

## Features

### Feed Reader

![FeedReader](/@Resources/Images/Wiki/FeedReader.png)

* Whole Skin is `Non-Ticking` means there is no process done, but from `Events` and `User-Interaction`
* Is currently able to display up to 25 [Feed-Entries](/@Resources/Images/Wiki/FeedEntries.png) (easy to extend) with their Images, Content, Titles and Links 
* `LeftClick` to show [Entry-Description](/@Resources/Images/Wiki/EntryDescription.png)
* `RightClick` to open up the article in your browser
* Download Progress Bar if Feeds contain Images (/@Resources/Images/Wiki/DownloadProgressBar.png)
* Split all your Feeds into seperate [Categories](/@Resources/Images/Wiki/Categories.png)
* Display up to 30 Feeds in a [List](/@Resources/Images/Wiki/Feeds.png)
* Use [ScrollBar](/@Resources/Images/Wiki/ScrollBar.png) if Amount is higher than resolution
* `ScrollUp` to scroll up
* `ScrollDown` to scroll down
* `LeftClick` on the up arrow to skip a whole page
* `LeftClick` on the down arrow to go back a whole page
* [Search](/@Resources/Images/Wiki/SearchButton.png) within all your feeds (only cached, not persistent)
* See how many [Hits](/@Resources/Images/Wiki/SeachResult.png) you got
* See the [Progress](/@Resources/Images/Wiki/SearchDatabaseProgress.png) of the parsing of all your Feeds
* `MiddleMouseClick` to hide the skin (don't loose the database)

To change your layout browse `Rainmeter\Skins\Minimal\@Resources\Variables\FeedReader\vFeedReader.inc`
but it is advised to stick with default at first.

To change your Feeds browse `Rainmeter\Skins\Minimal\@Resources\Scripts\FeedReader\FeedList.lua`. The list convention is explained with the Lua File `{Category, FeedName, FeedUrl, Pinned}`. Don't forget `,` in each Line.

### Media Player

![Screenshot](http://puu.sh/445Bo.png)

It is designed after [EdgePlayer 3.0](http://codymacri.deviantart.com/art/Edge-Player-3-0-363324372?ga_submit_new=10%253A1365016951) but offers additional features and removes in my opinion unneeded meters which are often not provided.

* MouseHover of the Controls (Displays another in another color if you mouseover the icons)
* LeftClick anywhere on the bar and drag'n'drop however you like to set the media player to a specific position of your song
* Smart Aligner - perfectly divides the bar into 100 parts
* RightClick and drag'n'drop to set the volume to a specified volume
* Low Profile Update - Updates and renders only necessary updates
* Hides if Player is inactive (EdgePlayer 3.0) and shows if Player is active again
* Fits each WorkArea automatically since it works with #SCREENAREAWIDTH#

### Notes

![Screenshot](http://puu.sh/445U0.png)

Revolutionary Note-Design which involves seperate NoteSkins which can be called smartly by detecting the `Active` State in the `[Rainmeter]` Configuration file.

* Fast Edit - `Left-Click` to edit the file with Windows Notepad, press ESC to close the file (AutoIt Script)
* Fast response - updates immediatly upon load or change
* Low Profile Update - Updates only on Change or on Load
* Easy Disposal - `Right-Click` to close the skin, but content stays saved
* Positioning - you can place each element whereever you like
* Expandable - Default are 5 notes, but you can easily expand this by copy & paste the Note1 files and rename them to NoteN where `N` is the next iteration in line. You can find it under `Minimal\Dock\Notes`. You will find 5 folders there to replicate. The script will automatically detect more notes if necessary

### Dynamic Calendar

![Screenshot](http://puu.sh/44WjF.png)

A horizontal display of your upcoming events not bound to a date limit but to the amount only

* Can cover almost infinite amount of calendars (only download time increases)
* Each calendar can use its own unique color
* Displays Date to Date if an appointment takes longer than one day
* All appointments are sorted by time and date

### Launcher

![Screenshot](http://puu.sh/45oiq.png)

A custom launcher, which can handle seperate things

* Calls a custom programs on keyword
* Search specific list of webpage
* Open websites
* Run normal windows commands

### System Stats

![Screenshot](http://puu.sh/44blV.png)

Easy Display of CPU, RAM and Download without the need for numbers. Minimum and Maximum are displayed through 2 seperate colors

* No Numbers
* No Cluttering
* One Icon displays all information
* if necessary `MouseOver` displays the current percentage as a tooltip

### System Access

![Screenshot](http://puu.sh/44bte.png)

Gives access to basic Windows functionality as the Trashbin or Volume

* Displays if trash is there
* `LeftClick` opens Trashbin
* `RightClick` clears Trashbin _without_ confirmation
* `MouseOver` displays how many files are in there
* `MouseWheelDown` decrease volume by 10%
* `MouseWheelUp` increase volume by 10%
* `LeftClick` toggles mute
* Displays different icons depending how loud it is

## To-Do

* RSS-Reader
* integrated weather?

## Known Bugs

* Icons don't display correct size because of `ImageTint` but thats on Rainmeter
* NowPlaying doesn't change the state, don't know if it is because of the plugin or Foobar
* Launcher cannot launch custom programs with whitespaces in it

## Thanks to

* [Rainmeter-Team](https://github.com/rainmeter/rainmeter/graphs/contributors) for [Rainmeter](http://rainmeter.net/cms/)
* [chrfb](http://chrfb.deviantart.com/) for his [ecqclipse 2](http://chrfb.deviantart.com/art/ecqlipse-2-quot-ico-quot-66339090) IconSet

## Contributor

* Original Author: [thatsIch](https://github.com/thatsIch)
* Contributors: [contributors](https://github.com/thatsIch/Minimal/graphs/contributors)
* powered by [SublimeText 2](http://www.sublimetext.com/2) and [Rainmeter Package](http://merlinthered.github.io/sublime-rainmeter/) by [Merlinthered](https://github.com/merlinthered)

## License

http://creativecommons.org/licenses/by-nc-sa/3.0/