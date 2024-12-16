
clear all  
set more off, perm 	
capture log close
cd "C:\Users\stefa\Documents\Ste\Trento\1° anno\2° semestre\Sociology of collective action\Quanti" 	
use "dataset\laborITA20082018_SCA - Copy.dta"

*Generate a variable for logistic sector workers
gen reg=0

replace reg = 1 if region == 19 | region == 12 | region == 9 | region == 17 | ///
region == 20 | region == 6 | region == 8 | region == 5

replace reg = 2 if region == 7 | region == 16 | region == 10 | region == 18

replace reg = 3 if region == 1 | region == 2 | region == 3 | region == 4 | ///
region == 11 | region == 13


label var reg "Italia areas"
label define reg_label 1 "North Italy" 2 "Center Italy" 3 "South Italy"
label values reg reg_label
tab reg

fre region, all
fre reg, all

gen logwork = 0 

replace logwork = 1 if isco1 == 9333 | isco2 == 9333 | isco3 == 9333 | ///
isco4 == 9333 | isco1 == 9621 | isco2 == 9621 | isco3 == 9621 | isco4 == 9621 /// 
| isco1 == 9334 | isco2 == 9334 | isco3 == 9334 | isco4 == 9334

label var logwork "Workers in logistic sector"
label define logwork_label 0 "Other workers" 1 "Workers in logistic sector"
label values logwork logwork_label
tab logwork


*Generate a variable for the type of action
gen spe = specificaction

*replace spe = 100 if specificaction == 1 | specificaction == 2 | ///
specificaction == 12 | specificaction == 15 |  specificaction == 21 | ///
specificaction == 22 | specificaction == 23 | specificaction == 25 | ///
specificaction == 26 | specificaction == 28 | specificaction == 32

replace spe = 0 if specificaction == 3 | specificaction == 5 | ///
specificaction == 6 | specificaction == 13 | specificaction == 17 | ///
specificaction == 27 | specificaction == 37 | specificaction == 34 | ///
specificaction == 33	

replace spe = 101 if specificaction == 7 | specificaction == 8 | ///
specificaction == 9 | specificaction == 10 | specificaction == 11 | ///
specificaction == 14 | specificaction == 16 | specificaction == 36 | ///
specificaction == 39
 
label var spe "Type of action"
label define spe_label 0 "Institutional action" 101 "Disruptive action"
label values spe spe_label
drop if spe>0 & spe<100
*100 "Traditional action"
fre spe

*Generate a variable for the two trade of our interest: Cgil and Cobas
gen sin=2

replace sin = 0 if actor_r1 == 8 | actor2_r1 == 8 | actor3_r1 == 8 | ///
actor4_r1 == 8 | actor5_r1 == 8 | actor6_r1 == 8 | actor7_r1 == 8 | ///
actor8_r1 == 8 
/*| actor_r1 == 10 | actor2_r1 == 10 | actor3_r1 == 10 | actor4_r1 == 10 | 
actor5_r1 == 10 | actor6_r1 == 10 | actor7_r1 == 10 | actor8_r1 == 10 | actor_r1 
== 25 | actor2_r1 == 25 | actor3_r1 == 25 | actor4_r1 == 25 | actor5_r1 == 25 | 
actor6_r1 == 25 | actor7_r1 == 25 | actor8_r1 == 25 */

replace sin = 1 if actor_r1 == 12 | actor2_r1 == 12 | actor3_r1 == 12 | ///
actor4_r1 == 12 | actor5_r1 == 12 | actor6_r1 == 1 | actor7_r1 == 12 | ///
actor8_r1 == 12 
/*| actor_r1 == 9 | actor2_r1 == 9 | actor3_r1 == 9 | actor4_r1 == 9 | actor5_r1 
== 9 | actor6_r1 == 9 | actor7_r1 == 9 | actor8_r1 == 9 | actor_r1 == 22| 
actor2_r1 == 22 | actor3_r1 == 22| actor4_r1 == 22 | actor5_r1 == 22| actor6_r1 
== 22 | actor7_r1 == 22 | actor8_r1 == 22 */

drop if sin>1

label var sin "Union Trade"
label define sin_label 0 "Cgil" 1 "Cobas"
label values sin sin_label
fre sin, all

/*replace var5 = "0" if var5 == "no" | var5 == "no "
replace var5 = "1" if var5 == "si" | var5 == "sì"
drop if var5 == "ns"
fre var5*/

destring [ var5 ], { generate(pol) | replace } 
fre pol
corr sin spe var5 
factor sin spe var5, pcf
screeplot, yline(1, lc(red)) xlab(0(1)7)
factor sin spe, pcf blanks(0.4)
	loadingplot, factor(3) combined ///
	msize(small)  mlabsize(small) mlabposition(1) ///
	xlab(-0.6(.2)0.8) ylab(-0.6(.2)0.8) yline(0) xline(0) ///
	tit("Unrotated solution") note ("") name(factor, replace) ///
	col(3) xsize(5) ysize(3) 

factor qc3_1 qc3_2 qc3_3 qc3_4 qc3_5 qc3_7, ///
	pcf blanks(0.4)
	rotate, blanks (0.4)
loadingplot, factor(3) combined ///
		msize(small)  mlabsize(small) mlabposition(1) ///
		xlab(-0.6(.2)0.8) ylab(-0.6(.2)0.8) yline(0) xline(0) ///
		tit("Orthogonal solution") note ("") name(factor_rot, replace) ///
		col(3) xsize(5) ysize(3)
		graph combine factor factor_rot, row(2)
 
 factor qc3_1 qc3_2 qc3_3 qc3_4 qc3_5 qc3_7, ///
	pcf blanks(0.4)
		rotate, promax blanks (.4)
		loadingplot, factor(3) combined ///
		msize(small)  mlabsize(small) mlabposition(1) ///
		xlab(-0.6(.2)0.8) ylab(-0.6(.2)0.8) yline(0) xline(0) ///
		tit("Oblique solution") note ("") name(factor_obli, replace) ///
		col(3) xsize(5) ysize(3) 
		*/

/*Tables
gen pro = specificaction
drop if pro==19*/

sort reg 
by reg: tab sin spe, row 

tab logwork sin, row
tab sin spe, row
ta sin specificaction, col nofreq
ta sin spe
logit spe sin
logistic spe sin
ta specificaction sin, col 

*odds for cgil doing distruptive action
disp 31.21/68.79
disp 1-(31.21/68.79)

*odds for cobas doing distruptive action
disp 63.16/36.84
disp 1-(63.16/36.84)

*odds ratio for cobas
disp (63.16*68.79)/(36.84*31.21)

*probability
disp ((63.16*68.79)/(36.84*31.21))/((63.16*68.79)/(36.84*31.21)+1)
  
  

 


