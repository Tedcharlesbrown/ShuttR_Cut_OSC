# ShuttR Cut OSC
  Credit to: Daniel Shiffman (Coding help), josephh (Coding help), Andreas Schlegel (Oscp5 Library)
 
 ## Change Log

### Version 0.0.1.0
 -  Initial Release.

### Version 0.0.2.0   
 -  Added User Field.
 -  Changed Highlight to work more like a toggle for the current channel selected.
 -  Fine now does something
 -  Double tap to home
 -  Saves IP and User Fields
 -  Added splash screen

### Version 0.0.2.1
-   network optimization
-   user feedback when connecting

### Version 0.0.3.0

-   Added encoder page
-   UI reacts to Live/Blind
-   Fixed some screen adjustment for different devices

### Version 0.0.4.0

-   Added dedicated number pad
-   Button optimization
-   Made encoder smaller
-   User channel input

### Version 0.0.5.0.1
-   Direct Selects
-   Channel select now iterates through selection
-   Fixed an error that caused channel selection to add a space
-   Path optimization

### Processing to OpenFrameworks
 
 ### Version 0.3.1
 - Connection / TCP
    -  Added connection awareness
        -   Added TCP Library to help with port connecting
    - Moved "Connect" to keyboard closing
-   Encoder Wheels
    -   Added "ticks"
    -   Adjusted OSC sensitivity when changing fine vs course
-   OSC Changes
    -   Homing a parameter does not affect the command line
-   Keyboard changes
    -   When channel button is clicked off, selected channel is restored
    -   Changing channels via the app does not clear channel selection
-   Visual changes
    -   Added outside stroke to the shutter assembly
    
    ### Version 1.0.1
- Connection / TCP
    -   Connection pings ever 30 seconds
-   OSC Changes
    -   Fixed bug that made flash button not work on Image page
    -   Added a way to affect intensity
    -   Double tap home to sneak
    -   Added syntax error to channel select
-   Visual changes
    -   Fixed bug that made GUI sized for iPhone 8+ only
    -   Added a fader image
    -   Direct selects are now parsed by text width
-   Business model
    -   Added free version vs paid version
 
    ### Version 1.0.2
-   Corrected version numbers
-   Added new screenshots

    ### Version 1.0.3
    -   Added Android version (Changed code to mimic)
-   OSC Changes
    -   "Diffusion" now works (was "Diffusn")
    
    ### Version 1.0.4
-   iOS
    -   Fixed connection issue when connecting to saved IP
-   Lite Version
    -   Added "LITE" Banner to deactivated pages
-   General
    -   Changed coffee text
    ### Version 1.0.4
-   Android
    -   Fixed cosmetic issue with Shutters
-   Metadata updates
    ### Version 1.1.0 (IOS ONLY)
    -   Added "Image" page
-   General
    -   "Selected Channel" now changes to fixture type if channel is selected
-   OSC Changes
    -   Auto-connect cancels if on settings page
    -   Auto-connect time is slowed down (IOS)
    ### Version 1.1.1
-   General
    - Fixed image page button range
    - Fixed "Selected Channel" text when no fixture is patched
    
