package require Tk

namespace eval ttk_colour_scheme_demo {

 # Obtain the current theme colours / default colours for widgets.
 # Perhaps there's a better way of doing it,
 # but the only way I know right now is to create some widgets and then read the values from their configure lists...

 proc getcolourlist {l} {
  button .getcolourlist_btn
  scrollbar .getcolourlist_scr
  text .getcolourlist_txt
  set conflist [concat [.getcolourlist_btn configure] [.getcolourlist_scr configure] [.getcolourlist_txt configure]]
  destroy .getcolourlist_btn .getcolourlist_scr .getcolourlist_txt
  set out ""
  foreach j $l {
   foreach i $conflist {
    if {[lindex $i 0] eq $j} {
     set out [concat $out [lindex $i end]]
     break
    }
   }
  }
  return $out
 }

 # --------------------------------------------------------------
 # -- This procedure sets the ttk colour scheme to match       --
 # --  the one set by the user using X resources,              --
 # --  or by the script programmer using 'tk_setPalette'       --
 # --  or 'tk_bisque'.                                         --
 # -- It uses the definition of the default ttk theme,         --
 # --  taken from /library/ttk/defaults.tcl in the Tk sources, --
 # --  with modifications to make it use the colours           --
 # --  of the current colour scheme.                           --
 # -- It's intended merely as a proof of concept, not as       --
 # --  a serious or production ready implementation.           --
 # --------------------------------------------------------------
 #namespace export reconfigure_default_ttk_theme
 proc reconfigure_default_ttk_theme {} {
  # The list of colour values we want to take from the classic Tk widgets, which will will be using to base the new ttk colour scheme on.
  variable cols_request
  set cols_request {
   -background
   -foreground
   -background
   -foreground
   -activebackground
   -selectbackground
   -selectforeground
   -troughcolor
   -disabledforeground
   -selectbackground
   -disabledforeground
   -selectbackground
   -troughcolor
  }
  # The list of indexes into the 'colors' array.
  variable cols_list
  set cols_list {
	-frame			
	-foreground		
	-window			
	-text   		
	-activebg		
	-selectbg		
	-selectfg		
	-darker 		
	-disabledfg		
	-indicator		
	-disabledindicator	
	-altindicator		
	-disabledaltindicator	
  }
  variable cols_array_list
  set cols_array_list ""
  foreach i [getcolourlist $cols_request] j $cols_list {
   set cols_array_list [concat $cols_array_list $j $i]
  }

  namespace eval ttk::theme::default {
    variable colors
#### I've left this here and commented out as a reference. This how the colours array was originally defined in the 'defaults.tcl' source.
#### As you can see, the colour values were hard coded.
#   array set colors {
#	-frame			"#d9d9d9"
#	-foreground		"#000000"
#	-window			"#ffffff"
#	-text   		"#000000"
#	-activebg		"#ececec"
#	-selectbg		"#4a6984"
#	-selectfg		"#ffffff"
#	-darker 		"#c3c3c3"
#	-disabledfg		"#a3a3a3"
#	-indicator		"#4a6984"
#	-disabledindicator	"#a3a3a3"
#	-altindicator		"#9fbdd8"
#	-disabledaltindicator	"#c0c0c0"
#   }
    # And now instead, we're setting them with colour values derived from the normal widgets.
    array set colors $ttk_colour_scheme_demo::cols_array_list   

    # I made some modifications to the following section: whereever #ffffff or 'white' was hardcoded, I replaced it with $colors(-window)
    # but otherwise it's left it was in 'defaults.tcl'
    ttk::style theme settings default {

	ttk::style configure "." \
	    -borderwidth 	1 \
	    -background 	$colors(-frame) \
	    -foreground 	$colors(-foreground) \
	    -troughcolor 	$colors(-darker) \
	    -font 		TkDefaultFont \
	    -selectborderwidth	1 \
	    -selectbackground	$colors(-selectbg) \
	    -selectforeground	$colors(-selectfg) \
	    -insertwidth 	1 \
	    -indicatordiameter	10 \
	    ;

	ttk::style map "." -background \
	    [list disabled $colors(-frame)  active $colors(-activebg)]
	ttk::style map "." -foreground \
	    [list disabled $colors(-disabledfg)]

	ttk::style configure TButton \
	    -anchor center -padding "3 3" -width -9 \
	    -relief raised -shiftrelief 1
	ttk::style map TButton -relief [list {!disabled pressed} sunken]

	ttk::style configure TCheckbutton \
	    -indicatorcolor $colors(-window) -indicatorrelief sunken -padding 1
	ttk::style map TCheckbutton -indicatorcolor \
	    [list pressed $colors(-activebg)  \
			{!disabled alternate} $colors(-altindicator) \
			{disabled alternate} $colors(-disabledaltindicator) \
			{!disabled selected} $colors(-indicator) \
			{disabled selected} $colors(-disabledindicator)]
	ttk::style map TCheckbutton -indicatorrelief \
	    [list alternate raised]

	ttk::style configure TRadiobutton \
	    -indicatorcolor $colors(-window) -indicatorrelief sunken -padding 1
	ttk::style map TRadiobutton -indicatorcolor \
	    [list pressed $colors(-activebg)  \
			{!disabled alternate} $colors(-altindicator) \
			{disabled alternate} $colors(-disabledaltindicator) \
			{!disabled selected} $colors(-indicator) \
			{disabled selected} $colors(-disabledindicator)]
	ttk::style map TRadiobutton -indicatorrelief \
	    [list alternate raised]

	ttk::style configure TMenubutton \
	    -relief raised -padding "10 3"

	ttk::style configure TEntry \
	    -relief sunken -fieldbackground $colors(-window) -padding 1
	ttk::style map TEntry -fieldbackground \
	    [list readonly $colors(-frame) disabled $colors(-frame)]

	ttk::style configure TCombobox -arrowsize 12 -padding 1
	ttk::style map TCombobox -fieldbackground \
	    [list readonly $colors(-frame) disabled $colors(-frame)] \
	    -arrowcolor [list disabled $colors(-disabledfg)]

	ttk::style configure TSpinbox -arrowsize 10 -padding {2 0 10 0}
	ttk::style map TSpinbox -fieldbackground \
	    [list readonly $colors(-frame) disabled $colors(-frame)] \
	    -arrowcolor [list disabled $colors(-disabledfg)]

	ttk::style configure TLabelframe \
	    -relief groove -borderwidth 2

	ttk::style configure TScrollbar \
	    -width 12 -arrowsize 12
	ttk::style map TScrollbar \
	    -arrowcolor [list disabled $colors(-disabledfg)]

	ttk::style configure TScale \
	    -sliderrelief raised
	ttk::style configure TProgressbar \
	    -background $colors(-selectbg)

	ttk::style configure TNotebook.Tab \
	    -padding {4 2} -background $colors(-darker)
	ttk::style map TNotebook.Tab \
	    -background [list selected $colors(-frame)]

	# Treeview.
	#
	ttk::style configure Heading -font TkHeadingFont -relief raised
	ttk::style configure Treeview \
	    -background $colors(-window) \
	    -foreground $colors(-text) ;
	ttk::style map Treeview \
	    -background [list disabled $colors(-frame)\
				selected $colors(-selectbg)] \
	    -foreground [list disabled $colors(-disabledfg) \
				selected $colors(-selectfg)]

	# Combobox popdown frame
	ttk::style layout ComboboxPopdownFrame {
	    ComboboxPopdownFrame.border -sticky nswe
	}
 	ttk::style configure ComboboxPopdownFrame \
	    -borderwidth 1 -relief solid

	#
	# Toolbar buttons:
	#
	ttk::style layout Toolbutton {
 	    Toolbutton.border -children {
 		Toolbutton.padding -children {
 		    Toolbutton.label
 		}
 	    }
 	}
 
 	ttk::style configure Toolbutton \
 	    -padding 2 -relief flat
 	ttk::style map Toolbutton -relief \
 	    [list disabled flat selected sunken pressed sunken active raised]
 	ttk::style map Toolbutton -background \
 	    [list pressed $colors(-darker)  active $colors(-activebg)]
     }
  }

  ttk::setTheme default
 }
};#end of 'ttk_colour_scheme_demo' namespace declaration 

ttk_colour_scheme_demo::reconfigure_default_ttk_theme

# I don't know why, but, for some reason the 'tk_setPalette' command can't be renamed (apparently doesn't exist) until you call it at least once.
# So I call it with no parameters using the 'catch' command, and then it can be renamed.
# The aim of this is to make tk_setPalette apply the chosen colours to the ttk widgets as well,
# by making a rapper that calls the original command and then my "reconfigure_default_ttk_theme" command immediately after.
catch { 
 tk_setPalette
}
rename tk_setPalette _tk_setPalette
proc tk_setPalette {args} {
 eval _tk_setPalette $args
 ttk_colour_scheme_demo::reconfigure_default_ttk_theme
}
# -------------------------------
# -- Prepare the demonstration --
# -------------------------------

# top buttons and info label
pack [button .b1 -text "Show/hide the font chooser"]\
     [button .b2 -text "Show the file chooser"]\
     [button .b3 -text "Change the colour scheme"]\
     [button .b4 -text "Run 'tk_bisque'" -command {tk_bisque; ttk_colour_scheme_demo::reconfigure_default_ttk_theme}]\
     [label .l]
.b1 configure -command {tk fontchooser [lindex "show hide" [tk fontchooser configure -visible]]}
.b2 configure -command {tk_getOpenFile}
.b3 configure -command {catch {tk_setPalette [tk_chooseColor -title "Colour to give to tk_setPalette"]}}
.l configure -text "Testy test" -wraplength 300 -justify left

# the little widget previews
frame .f -borderwidth 2 -relief ridge -padx 8 -pady 8

frame .f.f1 -borderwidth 2 -relief ridge -padx 4 -pady 4
pack [button .f.f1.b -text "Button"]\
     [scale .f.f1.s -label Scale -orient horiz]\
     [label .f.f1.l -text "Scrollbar"]
pack [scrollbar .f.f1.scr -orient horiz] -fill x
pack [checkbutton .f.f1.cb -text "Checkbutton"]\
     [radiobutton .f.f1.rb -text "Radiobutton"]\
     [entry .f.f1.en]
.f.f1.en insert 0 "Text entry"

frame .f.f2 -borderwidth 2 -relief ridge -padx 4 -pady 4
pack [ttk::button .f.f2.b -text "Button"]\
     [ttk::label .f.f2.scl -text "Scale"]\
     [ttk::scale .f.f2.s -orient horiz -variable vv]\
     [ttk::progressbar .f.f2.pb -variable vv -maximum 1.0]\
     [ttk::label .f.f2.l -text "Scrollbar"]
pack [ttk::scrollbar .f.f2.scr -orient horiz] -fill x
pack [ttk::checkbutton .f.f2.cb -text "Checkbutton"]\
     [ttk::radiobutton .f.f2.rb -text "Radiobutton"]\
     [ttk::entry .f.f2.en]
.f.f2.en insert 0 "Text entry"

grid [label .f.l1 -text "Classic widgets"] [label .f.l2 -text "ttk widgets"]
grid .f.f1 .f.f2
pack .f