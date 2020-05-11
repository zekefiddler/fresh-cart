# fresh-cart
## Introduction
A script to find available delivery Dates for a Fresh Cart:    
This is by no means a ready-for-prime-time script (no pun intended).  It's just rough and dirty hacked together tool to get a jump on delivery times. I am aware that many of my design patterns here are atrocious. Robot Framework scripts hold the potential to be super easily readable, if implemented wisely. The code in this repo however, is certainly no great example of that. 

#### TLDR
The script will log into amazon and navigate to your fresh cart. 
It will then proceed to checkout and start looking for available delivery time slots over the next few days.
There are some built in pauses that wait for user interaction while logging in and navigating to the delivery time selection.  See [Some Notes on the Script](#some-notes-on-the-script) for how to disable these if desired. 


### To Setup:
1: Create a virtual environment with Python3 as the executor. 

I use virtualenv, but Anaconda or some other environment management tool should work just as well.  

 > Note: Virtualization isn't necessary to run the script, but it certainly makes dependency issues easier to manage if they happen to arise.  

##### Example using `virtualenv`: 
1: Create a new virtual environment.       
 `virtualenv -p {path to your python3 executable} rf_amazon_venv`     

 2: Spin up that virtual environment.        
 `source rf_amazon_venv/bin/activate`

3: install the requirements    
`pip3 install -r requirements.txt`


This should get you set up to run the script successfully.  

### To run the script:

##### Method 1:

Pass login info from the command line

`robot -v login:fakeUser@myfakeemail.com -v password:theMostUnfortunatePassword avail_deliveries.robot`

##### Method 2: 
Hard code your login info in the robot file

```
| *** Variables *** |

| ${login} |  fakeUser@myfakeemail.com |  
| ${password} | theMostUnfortunatePassword  | 
```
then you can simply kickoff the script with `robot avail_deliveries.robot` 

##### Other Methods:
 Store your login info as env variables that can be pulled from within the script. Or store you login info in separate variable files... the universe is full of possibilities.  It's up to you to decide how to use them.

#### Some Notes on the Script

> Note: I have 2fa set up with my amazon account, so the login process has a pause that waits for me to confirm that I have logged in successfully.  The dialog to confirm will likely be hiding behind the browser window once you've interacted with the browser to complete your 2fa. You must command-tab back to it and click `ok` to proceed. 

If you don't use 2fa you can comment out the line that kicks up this dialog with a leading `#`:
``` 
# |   | Pause Execution | Waiting for 2FA: \nClick `OK` once you are completely logged in |
```
> There are a couple of other `Pause Execution` lines in the script that can be commented out as well.  I have them in there so that I can see what items (if any) will not make it to my cart if they are no longer available. But if you wish to cut to the chase, you can comment them out with a hash`#`, and they will be disregarded.  

The `Pause Execution` line I would not comment out is the one in the `Alert` Keyword definition.  That pause is necessary if you want to select from a list of available time slots.  Otherwise the script will plow through it's loop and by doing so, it will select the first available slot. It will also not be clear that this was done until you log back in to Amazon and navigate to checkout to find that you have a slot already reserved.

#### More Info About Robot Framework and the Selenium Library Used in the Script Here:

`robot --help` will give you a list of other command line options available, such as stashing all the log files and screenshots in a different directory and other nifty tricks.

To learn more about Robot Framework you can read more at [RobotFramework.org](https://robotframework.org/) or dive directly into the [docs](http://robotframework.org/robotframework/)

To see what other selenium keywords are available you can check out the [Selenium Library Keyword Documentation](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
