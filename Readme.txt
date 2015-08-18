Autohotkey script to add Netflix to Steam Big Picture, with controller support and Search functionality.

This script is designed to work on a 1920x1080 monitor using an Xbox 360 controller.

Controls:

Left stick to mouse move Right stick to control volume A button to mouse click B button to go back (only works when back arrow is visible in upper left corner, also exits from search when no arrow visible. During playbuck wiggles the mouse to show back arrow) X button to Resume last watched or play/pause during playback Y button to search (only from main screen with Search icon visible) D-Pad to scroll on main screen Start+Back together to exit, alternatively use Esc (See warning)

The various .bmp files are necessary for the script to work; it searches the screen for the images and then clicks on them. Keep them in the same directory as the executable for the script to work

This script MUST be run as administrator for search functionality. The Search uses the Windows On Screen Keyboard, and in order for Autohotkey to interact with it it has to be an elevated process (i.e. run as Administrator). If it is not, then you will be unable to click on the On Screen Keyboard unless you use a physical mouse. To automatically run the script as Administrator, it must be compiled into an .exe (download Autohotkey here: http://www.autohotkey.com/. Once installed simply right-click and select compile). Then: 1) Right click the compiled script 2) Select the Compatability tab 3) check "Run as Administartor"

To add to Steam simply click "+ Add a Game" or the + button when in Big Picture Mode, then navigate to the executable.

!!!!!!!WARNING!!!!!!! DO NOT exit Netflix from the X button in the top right OR by using Alt+F4. ONLY exit using Start+Back or Escape Failing to use the specified methods leaves the script mapping the mouse to the controller running.

I claim NO credit for this, I merely edited and combined scripts I found by Googling.

~Trigonous
