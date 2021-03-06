## Part 1 of 2 = Extracts F1 F2 , saves to text file who's content is to be copied and pasted into the second part of the script. 
# This script is a modified version of the original script by Mietta Lennes entitled "extract f1,f2,f3 at midpoint"
# Combined final version by Jack Bowers SJSU 8/2011. 

form Analyze formant values from labeled segments in files
	comment Directory of sound files
	text sound_directory ./
	sentence sound_file_extension .wav
	
    comment Directory of TextGrid files
	text textGrid_directory ./
	sentence textGrid_file_extension .TextGrid
	
	comment Full path of the resulting text file:
	text resultfile ./f1f2-outpu-20161107.txt
	
	comment Which tier do you want to analyze?
	sentence Tier Vowels
	
	comment Formant analysis parameters
	positive Time_step 0.01
	integer Maximum_number_of_formants 5
	positive Maximum_formant_(Hz) 5000_(=adult male)
	positive Window_length_(s) 0.025
	real Preemphasis_from_(Hz) 50
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" 

Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)
titleline$ = "Vowel" + tab$ + "F1" + tab$ + "F2" + newline$
fileappend "'resultfile$'" 'titleline$'

#titleline$ = "Text special..." + tab$ + "F1" + tab$ + "Center" + "F2" + "Half Times 24 0" + tab$ +  "interval_label$" + newline$
#fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:

for ifile to numberOfFiles
	filename$ = Get string... ifile
	
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Formant (burg)... time_step maximum_number_of_formants maximum_formant window_length preemphasis_from
	
	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		
		# Find the tier number that has the label given in the form:
		# 'tier' is a variable who's label should be set in 'Form' section'
		call GetTier 'tier$' tier
		numberOfIntervals = Get number of intervals... tier
		
		# Pass through all intervals in the selected tier:
		for interval to numberOfIntervals
			label$ = Get label of interval... tier interval
			if label$ <> ""
			
			# if the interval has an unempty label, get its start and end:
				start = Get starting point... tier interval
				end = Get end point... tier interval
				midpoint = (start + end) / 2
				
			# Get the formant values at that interval
			# We extract from the midpoint; this can be changed to 
				
				select Formant 'soundname$'
				f1 = Get value at time... 1 midpoint Hertz Linear
				f2 = Get value at time... 2 midpoint Hertz Linear
		
				
			# Save result to text file:
				resultline$ = "'label$'	'f1:0'	'f2:0'	 ''newline$'"
				#resultline$ = "'Text special...' 'f1:0'	'Centre'	'f2:0'	'Half Times 24 0'	'label$'	''newline$'"
				fileappend "'resultfile$'" 'resultline$'
				select TextGrid 'soundname$'
			endif
		endfor
		
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Formant 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove


#------------------------------------------------------
# This procedure finds the number of a tier that has a given label.

procedure GetTier name$ variable$
        numberOfTiers = Get number of tiers
        itier = 1
        repeat
                tier$ = Get tier name... itier
                itier = itier + 1
        until tier$ = name$ or itier > numberOfTiers
        if tier$ <> name$
                'variable$' = 0
        else
                'variable$' = itier - 1
        endif

	if 'variable$' = 0
		exit The tier called 'name$' is missing from the file 'soundname$'!
	endif

endproc
#######

# Part II;  Draw Upsidown V Chart 

#Be sure to comment this part out or copy paste the first part from this doc.
# Also make sure to update the values herein before each new running.
# Eventually we will try to automate the whole process with a more advanced script which 

----------------------------------------------------------------------------
# Script Begins Here
# Put F1 (between ( axese may need to be changed if including nasals)300 and 800 Hz) along the horizontal axis,
# and F2 (between 600 and 3600 Hz) along the vertical axis.

Axes... 200 900 600 2800 

# Draw a rectangle inside the current viewport (selected area),
# with text in the margins, and tick marks in steps of 100 Hz along the F1 axis,
# and in steps of 200 Hz along the F2 axis.

Draw inner box
Grey
Text top... no Yucunany Mixtec Vowels
Text bottom... yes %F1 (Hz)
Text left... yes %F2 (Hz)
Marks bottom every... 1 200 yes yes yes
Marks left every... 1 200 yes yes yes

## Part 2/2
# Draw large phonetic symbols at the vowel points.
#Change first two columns of data for each new vowel token data
#Change vowel in final column accordingly
#Add -vowel,-word derrived from,-file#, sequentially (w/in comment section)
#V's 1-3 (random), V's 4,5 ('two'03)
#Insert resulting txt file from part 1 of script which extracts label and mean f1 & f2.#
 #Text special...  495.6 Centre 1274.0 Half Times 26 0 ɛ  
 #Text special...  457.5 Centre 1878.5 Half Times 26 0 ɛ 

# Need to change below with each new data set.
#V Population results from 02/18/12
Teal
Text special... 726	Centre	1300	Half Times 18 0	a
Text special... 594	Centre	1398	Half Times 12 0	a
Text special... 717	Centre	1445	Half Times 12 0	a
Text special... 566	Centre	1296	Half Times 12 0	a
Text special... 723	Centre	1419	Half Times 12 0	a
Text special... 572	Centre	1423	Half Times 12 0	a
Text special... 562	Centre	1509	Half Times 12 0	a
Text special... 564	Centre	1516	Half Times 12 0	a
Text special... 691	Centre	1525	Half Times 12 0	a
Text special... 476	Centre	1547	Half Times 12 0	a
Text special... 554	Centre	1609	Half Times 12 0	a
Text special... 542	Centre	1519	Half Times 12 0	a
Text special... 586	Centre	1472	Half Times 12 0	a
Text special... 589	Centre	1500	Half Times 12 0	a
Text special... 429	Centre	1479	Half Times 12 0	a
Text special... 491	Centre	1598	Half Times 12 0	a
Text special... 594	Centre	1409	Half Times 12 0	a
Text special... 629	Centre	1557	Half Times 12 0	a
Text special... 696	Centre	1508	Half Times 12 0	a
Text special... 535	Centre	1494	Half Times 12 0	a
Text special... 504	Centre	1617	Half Times 12 0	a
Text special... 644	Centre	1486	Half Times 12 0	a
Text special... 522	Centre	1515	Half Times 12 0	a
Text special... 549	Centre	1563	Half Times 12 0	a
Text special... 583	Centre	1478	Half Times 12 0	a
Text special... 561	Centre	1833	Half Times 12 0	a
Text special... 623	Centre	1568	Half Times 12 0	a
Text special... 660	Centre	1384	Half Times 12 0	a
Text special... 648	Centre	1415	Half Times 12 0	a
Text special... 743	Centre	1688	Half Times 12 0	a
Text special... 773	Centre	1534	Half Times 12 0	a
Text special... 558	Centre	1428	Half Times 12 0	a
Text special... 600	Centre	1479	Half Times 12 0	a
Text special... 545	Centre	1896	Half Times 12 0	a
Text special... 589	Centre	1734	Half Times 12 0	a
Text special... 767	Centre	1443	Half Times 12 0	a
Text special... 632	Centre	1363	Half Times 12 0	a
Text special... 656	Centre	1458	Half Times 12 0	a
Text special... 558	Centre	1727	Half Times 12 0	a
Text special... 530	Centre	1419	Half Times 12 0	a
Text special... 632	Centre	1541	Half Times 12 0	a
Text special... 554	Centre	1387	Half Times 12 0	a
Text special... 521	Centre	1395	Half Times 12 0	a
Text special... 410	Centre	1140	Half Times 12 0	a
Text special... 683	Centre	1393	Half Times 12 0	a
Text special... 764	Centre	1404	Half Times 12 0	a
Text special... 625	Centre	1426	Half Times 12 0	a
Text special... 705	Centre	1491	Half Times 12 0	a
Text special... 742	Centre	1414	Half Times 12 0	a
Text special... 661	Centre	1412	Half Times 12 0	a
Text special... 743	Centre	1433	Half Times 12 0	a
Text special... 747	Centre	1431	Half Times 12 0	a
Text special... 595	Centre	1457	Half Times 12 0	a
Text special... 569	Centre	1482	Half Times 12 0	a
Text special... 602	Centre	1429	Half Times 12 0	a
Text special... 626	Centre	1435	Half Times 12 0	a
Text special... 754	Centre	1482	Half Times 12 0	a
Text special... 611	Centre	1596	Half Times 12 0	a
Text special... 632	Centre	1562	Half Times 12 0	a
Text special... 538	Centre	1471	Half Times 12 0	a
Text special... 526	Centre	1475	Half Times 12 0	a
Text special... 700	Centre	1421	Half Times 12 0	a
Text special... 612	Centre	1412	Half Times 12 0	a
Text special... 637	Centre	1472	Half Times 12 0	a
Text special... 538	Centre	1584	Half Times 12 0	a
Text special... 499	Centre	1514	Half Times 12 0	a
Text special... 530	Centre	1604	Half Times 12 0	a
Text special... 608	Centre	1450	Half Times 12 0	a
Text special... 621	Centre	1463	Half Times 12 0	a
Text special... 662	Centre	1636	Half Times 12 0	a
Text special... 399	Centre	1736	Half Times 12 0	a
Text special... 618	Centre	1405	Half Times 12 0	a
Text special... 499	Centre	1880	Half Times 12 0	a
Text special... 590	Centre	1765	Half Times 12 0	a
Text special... 451	Centre	1693	Half Times 12 0	a
Text special... 608	Centre	1055	Half Times 12 0	a
Text special... 705	Centre	1187	Half Times 12 0	a
Text special... 472	Centre	1219	Half Times 12 0	a
Text special... 670	Centre	1350	Half Times 12 0	a
Text special... 701	Centre	1395	Half Times 12 0	a
Text special... 781	Centre	1268	Half Times 12 0	a
Text special... 641	Centre	1408	Half Times 12 0	a
Text special... 721	Centre	1425	Half Times 12 0	a