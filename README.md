# segmentation
semi-automatically segment the echo

1.	Open up the viewer4D.m to see which plane image is the best to segment out the endocardium and epicardium (The plane that I used was xz-plane)
2.	Run the manual_segmentation_gui.m and load the bMode image of the sample.
(*Make sure to save the loaded b mode image as bMode.mat in the same folder)
3.	Manually segment the endocardium and the epicardium using the GUI every 3 slices to get at least 30 slices (± middle slice)
(*Once each endocardium and epicardium contours are drawn, double clicking in the middle saves both masks into the created files epi_1_temp and endo_1_temp)
