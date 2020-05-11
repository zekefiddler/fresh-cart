| *** Settings *** |
| Library | SeleniumLibrary |
| Library | DateTime |
| Library | Process |
| Library | Dialogs |

| suite setup |  open browser | http://amazon.com | chrome |

| *** Variables *** |

| ${login} |  amazon login goes here |  
| ${password} | you password here  |  

| ${days_out} | 3 |
| ${paginations} | 0 |

| ${day_button} | //ul[@class='a-unordered-list a-nostyle a-button-list a-declarative a-button-toggle-group a-horizontal ss-carousel-items'] |
| ${unavailable} | //span[contains(text(),'No doorstep delivery windows are available for')] |
| ${alert_content} | //div[@id='slot-container-UNATTENDED']//span[@class='a-size-base-plus'] |

| *** Test Cases *** |

| Click Sign In |
|    | Run Process | say "Signing In" | shell=true |
|    | click element | //span[contains(text(),'Hello, Sign in')] |

| Log In |
|   | [Documentation] | You can comment out the last line here if you don't have 2fa enabled |
|   | Input Text | //input[@id='ap_email'] | ${login} | clear=true |
|   | Click Element | //input[@id='continue'] |
|   | Input Password | //input[@id='ap_password'] | ${password} | clear=true |
|   | click element | //input[@id='signInSubmit'] |
|   | Pause Execution | Waiting for 2FA: \nClick `OK` once you are completely logged in |

| open cart |
|    | [Documentation] | You can comment out the "Pause Execution" line if you prefer to race to the date picker |
|    | Click ELement | //span[@class='nav-cart-icon nav-sprite'] |
|    | Pause Execution | Review Options: Click `OK` to Proceed |
|    | Wait until element is visible |  //input[starts-with(@name,'proceedToALMCheckout')] |

| Proceed to checkout |
|    | Click Element | //input[starts-with(@name,'proceedToALMCheckout')] |
|    | Wait until element is visible | //a[@name='proceedToCheckout'][contains(text(),'Continue')] |

| Continue to checkout |
|    | [Documentation] | You can comment out the "Pause Execution" here as well
|    | ...             |  if you prefer to race to the date picker |
|    | Pause Execution | Review Options Again: Click `OK` to Proceed |
|    | Click Element | //a[@name='proceedToCheckout'][contains(text(),'Continue')] |
|    | Sleep | 2 |
|    | Wait Until Element is Visible | //span[contains(text(),'No doorstep delivery windows are available for Tod')] |

| view days |
|    | Sleep | 1 |
|    | FOR | ${trys} | IN RANGE | 1 | 40 |
|    |     | Check Next ${days_out} Availability Dates |
# |    |     | Check Availability Dates |
|    |     | Reload Page |
|    |     | Sleep | 10 |
|    |     | Reload Page |


| *** Keywords *** |

| Check Next ${days_out} Availability Dates |
|    | Log To Console | Checking Availability By Date |
|    | ${today}= | get current date | result_format=%Y-%m-%d |
|    | Log to console | Today is ${today}  |
|    | Loop Through Days | ${today} | ${days_out} |

| Loop Through Days |
|    | [Documentation] | This will loop through the the given number of days and check for availability |
|    | [Arguments] | ${this_start_Date} | ${loops} |
|    | FOR | ${button} | IN RANGE | 0 | ${loops} |
|    |      | log to console | Button: ${button} 
|    |      | ${date} | Add Time To Date | ${this_start_date} | ${button} days | result_format=%Y-%m-%d |
|    |      | ${button_no} | evaluate | ${button} + 1 |
|    |      | log to console | Date: ${date} |
# |    |      | Click Element | ${day_button}/li[${button_no}] |
|    |      | Click Element | //span[@id='date-button-${date}']
|    |      | Log to console | Button Clicked | 
|    |      | Sleep | 2 |
|    |      | ${availabities} | Run Keyword And Return Status |
|    |      | ... | Page Should Not Contain Element | //div[@id='slot-container-${date}']${alert_content} |
|    |      | Exit For Loop If | ${availabities} |
|    |      | ${alert} | get text | //div[@id='slot-container-${date}']${alert_content} |
|    |      | log to console | ${alert} |
|    |      | ${not_available} | Run Keyword and Return Status |
|    |      | ... | Should Contain | ${alert} | No doorstep delivery windows |
|    |      | Log To Console  | Available Status ${not_available} |
|    |      | Continue For Loop IF | ${not_available} |
|    |      | Log To Console | This is after the continue for loop |
|    | Run Keyword If | ${availabities} | Alert |

| Alert |
|    | Log To Console | Presumably we found an availability |
|    | Run Process | say "We Found Some Available Delivery Times!" | shell=true |


| Check Availability Dates |
|    | [Documentation] | This is legacy code that is no longer needed. It checked through multiple pages of dates |
|    | ...             | However, recent changes on Amaon Fresh only show three days out, and |
|    | ...             | results have shown that availability opens up within the first two days out |
|    | Log To Console | Checking Availability By Date |
|    | ${today}= | get current date | result_format=%Y-%m-%d |
|    | Log to console | Today is ${today} 
|    | Loop Through Days | ${today} | 3 |
|    | ${next_four} | Add Time To Date | ${today} | 5 days | result_format=%Y-%m-%d | 
|    | Log To Console | Next Four starts with: ${next_four} |
|    | Click Element | //button[@id='nextButton-announce']//img |
|    | Sleep | 3 |
|    | Loop Through Days | ${next_four} | ${paginations} |
|    | FOR | ${x} | IN RANGE | 0 | 4 |
|    |     | Log To Console | Next Four starts with: ${next_four} |
|    |     | ${next_four} | Add Time To Date | ${next_four} | 4 days | result_format=%Y-%m-%d |
|    |     | Click Element | //button[@id='nextButton-announce']//img |
|    |     | Sleep | 3 |
|    |     | Loop Through Days | ${next_four} | 1 |





 