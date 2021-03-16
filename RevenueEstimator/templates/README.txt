April 6, 2020  jburgoon

The "old" folder in this template directory contains deprecated versions of the Excel template for V1 downloads.

My convention has been to leave the latest version in the main templates directory, and then copy it renamed to "B325_Student_Fee_Revenue_V1_template.xlsx", which is the file name called by ColdFusion when someone clicks the "Download V1 Report" button.  I usually append a date notation to whatever file name Dan provides, and occasionally replace spaces with underscores.

Right click in any pivot table, seleect Pivot Table options, go to the data tab, and make sure that the "Refresh when opening" checkbox is checked.  This will overwrite the data in the RawData tab when the user downloads the file.  Interestingly, cell formatting in the RawData field seems to be over-written as well.  If we figure out why this happens I'll add a note here.

6-15-2020 jburgoon
NOTE: We are having intermittent CF file permission POIExceptions on opening Dan's templates.  Gary suggested I rebuild the template using a fresh Excel blank file, and copying the tabs one at a time.  I did this.  We will see if that helps.

