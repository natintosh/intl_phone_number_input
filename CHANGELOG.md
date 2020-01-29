## [0.3.0]
  - Added support for RTL languages to be presented in the correct alignment
  - Added new mode selection for dropdown, bottom sheet and dialog
  - Added country names to bottom sheet and dialog country list
  - Added search box to filter countries in the bottom sheet and country list
  - Added For the above - an option to pass in a search box decoration
  - Added ignoreBlank boolean to avoid input error message when left blank
  - Added nameTranslations map to country model as preparation for future country name translation support
  - Added Also for the above added the locale String field option (When translations will be supported this will define the requested translation language e.g. en_US, fr_FR etc.)
  - Added function to get initial country ISO2 code when the input has pre-defined phone number (good for an "edit" input)
  - Improved loading time for country list
  - Changed When only one country passed in there is no need for any selector widget so a plain "Item" widget will be shown instead
  
## [0.2.1]
  - Bug fixes
  - Improvement for reliability

## [0.2.0]
  - As You Type Formatter: The Package now formats the input to it's selected national format
  - You can now disable input formatting by setting inputFormat to false
  - Replaced TextField with 
  - AutoValidate
  - TextStyle

## [0.1.3]
  -  onInputChanged now returns a new PhoneNumber Model
  -  You can create a PhoneNumber object from PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode]); 
  -  You can now parse phoneNumber by calling   PhoneNumber.getParsableNumber(String phoneNumber, String isoCode) or `PhoneNumber Reference`.parseNumber()

## [0.1.2+2]
  - Bug fixed

## [0.1.2]
  - TextField now formats whenever TextEditingController Text is changed

## [0.1.1]
  - Added TextEditingController
  - Added KeyboardActionType
  - Added callback that listens to keyboard action 

## [0.1.0]
 - Minor bug fixed
 - #### What's new
    * Added focus node
    * Custom list of countries e.g. ['NG', 'GH', 'BJ' 'TG', 'CI']
    * Country Flag and Logo now formatted

## [0.0.10]
 - Minor changes to the source file
 
## [0.0.9]
 - Critical bug fixed caused by changing source files and packages
 
## [0.0.8]
 - Minor changes to the source file
 - Added example
 - Updated README.md
 - Added examples to README.md

## [0.0.7]
 - Critical bug fixed 
 - Updated README.md

## [0.0.6]
 - Updated README.md
 - Fixed issues with text input not validating
 - Fixed issues with text input not parsing

## [0.0.5]
 - Critical bug fixed 
 - Removed example
 - Fixed countries.json assets not loading
 
## [0.0.4]
 - Critical bug fixed 
 - Fixed image assets not loading

## [0.0.3]
 - Critical bug fixed 
 - Added examples
 - Fixed image assets not loading

## [0.0.2]
 - Critical bug fixed 
 - Updated README.md

## [0.0.1]
 ###### Initial project release
 - Updated README.md
 - Added support for custom input decoration
 - Added support for custom input border