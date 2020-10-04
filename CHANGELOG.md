## [0.5.2+2]
## [0.5.2+1]
  - Fixed issue with pub.dev analysis

## [0.5.2]
  - Updated dependencies
  - <b>Breaking Change</b> Changed autoValidate to autoValidateMode
  - Added getPhoneNumberType static method to PhoneNumber.
  - Added bottomSheet background color property to SelectorConfig
  - Updated Egypt country name
  - Enable alpha 3 code in country search criteria
  - Added country comparator to SelectorConfig to sort Country on initial load
   ```dart
        // Should return -1 if A precedes B, 0 if A is equal to B and 1 if B precedes A
   ```

## [0.5.1]
  - Fixed issue with pt_br.png asset not loading

## [0.5.0]
  - Fixed issue with text input autoFocus when formatInput is set to false
  - Added new locale translations for ["sk" "se" "pl" "no" "ja" "it" "zh" "nl" "de" "fr" "es" "en" "pt_BR"]
     * Made possible by [@SimonFM](https://github.com/SimonFM) and [@diefferson](https://github.com/diefferson)
  - Added selector configuration `selectorConfig` parameter which enables you to
     * Add emoji flag support
     * Add option to turn off flags
  - <b>Breaking Change</b> `selectorType` has been moved to `selectorConfig`
  - Fixed autoFocus search search field
  - Fixed keyboard covers bottom sheet while search
  - <b>Breaking Change</b> Removed factory constructors `withCustomBorder` and `withCustomDecoration`


## [0.4.6+2]
  - Removed selector button left padding

## [0.4.6+1]
  - Fixed setState() or markNeedsBuild called during build

## [0.4.6]
  - Fixed incorrect cursor positioning while editing

## [0.4.5]
  - Added maxLength property to set length limit
  - Fixed getter 'hash' was called on null.

## [0.4.4]
  - Updated package documentation
  - Added selector button padding on error
  - Fixed issue with first digit getting removed

## [0.4.3]
  - Fixed issue with first digit getting removed

## [0.4.2]
  - Fixed issue with keyboard and multiple rebuilds

## [0.4.1+1]
  - Fixed issue with PhoneInputSelectorType.DIALOG

## [0.4.1]
  - Updated Cayman Island dial code
  - Added selectorTextStyle parameter
  - Improve load up time
  - Fixed NoSuchMethodError: The getter 'owner' was called on null

## [0.4.0+2]
  - Fixed NoSuchMethodError: The getter 'owner' was called on null

## [0.4.0+1]
  - Fixed issue with Validation error on initial value

## [0.4.0]
  - Added new initialValue parameter that accepts a PhoneNumber object
  - Added autoFocus option
  - Added Keys and Helper class for testing
  - Updated static method getParsableNumber from PhoneNumber
  - Removed initialCountry2letterCode parameter
  - Fixed issue with textController calling disposed if user defines the controller
  - Fixed issue with with country picker alignment gone wrong when a single country is set
  - Fixed NullPointerException thrown on getRegionInfoFromPhoneNumber

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