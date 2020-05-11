# fresh-cart
## Introduction
A script to find available delivery Dates for a Fresh Cart:    
This is by no means a ready-for-prime-time script (no pun intended).  It's just rough and dirty hacked together tool to get a jump on delivery times. I am aware that many of my design patterns here are atrocious. Robot Framework scripts are designed to be super easily readable if implemented wisely. But this repo is for sure not a great example. 

#### TLDR
The script will log into amazon and navigate to your fresh cart. It will then proceed to checkout and start looking for available delivery time slots over the next few days. 



### To Setup:
1: Create a virtual environment with Python3 as the executor
> Example using `virtualenv`:    
> `virtualenv -p {path to your python3 executable} rf_amazon_venv     

2: Spin up that virtual environment and install the requirements `pip3 install -r requirements.txt`

This should get you up and running.

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
then you can simple kickoff the script with `robot avail_deliveries.robot` 

##### Other Methods:
 Store your login info as env variables that can be pulled from within the script. Or store you login info in separate variable files... the universe is full of possibilities.  It's up to you to decide how to use them.

#### Some Notes on the Script

> Note: I have 2fa set up with my amazon account, so the login process has a pause that waits for me to confirm that I have logged in successfully.  The dialog to confirm will likely be hiding behind the browser window. The process will be visible on your dock as a terminal application. You can command-tab back to it to click `ok` and proceed.    
You can also comment out the line that kicks up this dialog like this:
``` 
# |   | Pause Execution | Waiting for 2FA: \nClick `OK` once you are completely logged in |
```
> There are a couple of other `Pause Execution` lines in the script that can be commented out as well.  I have them in there so that I can see what items (if any) will not make it to my cart if they are no longer available. But if you wish to cut to the chase, you can prepend those lines with a hash `#` and the will be disregarded.

#### More Info About Robot Framework and the Selenium Library Used in the Script Here:

`robot --help` will give you a list of other options available such as stashing all the log files and screenshots in a different directory and other nifty tricks.

To learn more about Robot Framework you can read more at [RobotFramework.org](https://robotframework.org/) or dive into the [docs](http://robotframework.org/robotframework/)

To see what other selenium keywords are available you can check out the [Selenium Library Keyword Documentation](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
