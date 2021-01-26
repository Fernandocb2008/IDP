
*** Load data
use "${enaho_2019}/enaho01-2019-200.dta", clear


gen idhogar str15=conglome+vivienda+hogar
*gen aniorec=real(aÑo)

*** Nos quedamos con los miembros del hogar
	keep if (p204==1)
	
			
*** Tamaño del hogar
	bysort idhogar: gen tamhog=_N
	gen ltamhog=log(tamhog)
	
	label var tamhog  "Tamaño del hogar"
	label var ltamhog "Logaritmo tamaño del hogar"

	recode tamhog (1=1)(2=2)(3/4=3)(5/6=4)(7/max=5), gen(xtamhog)
	tab xtamhog, gen(tamhog)
	
	label var tamhog1	"Hogar unifamiliar"
	label var tamhog2	"Hogar con dos miembros"
	label var tamhog3	"Hogar con tres o cuatro miembros"
	label var tamhog4	"Hogar con cinco o seis miembros"
	label var tamhog5	"Hogar con siete o más miembros"

	label value tamhog1-tamhog5 dummy
	
	
*** Tipología del hogar
	recode p203 (1=1)(2=2)(3=3)(4/7=4)(11=4)(10=5), gen(parent)
	label define parent 1 "Jefe" 2"Conyuge" 3"Hijo" 4"Otro pariente" 5"Otro no pariente", modify
	label value parent parent
	
	tab parent, gen(xparent_)
	bysort idhogar: egen parent_1=max(xparent_1)
	bysort idhogar: egen parent_2=max(xparent_2)
	bysort idhogar: egen parent_3=max(xparent_3)
	bysort idhogar: egen parent_4=max(xparent_4)
	bysort idhogar: egen parent_5=max(xparent_5)
	
	gen     tip_hog=1  if (parent_1==1 & parent_2==1 & parent_3==0 & parent_4==0 & parent_5==0)
	replace tip_hog=2  if (parent_1==1 & parent_2==1 & parent_3==1 & parent_4==0 & parent_5==0)
	replace tip_hog=3  if (parent_1==1 & parent_2==0 & parent_3==1 & parent_4==0 & parent_5==0)
	
	replace tip_hog=4  if (parent_1==1 & parent_2==1 & parent_3==0 & parent_4==1 & parent_5==0)
	replace tip_hog=5  if (parent_1==1 & parent_2==1 & parent_3==1 & parent_4==1 & parent_5==0)
	replace tip_hog=6  if (parent_1==1 & parent_2==0 & parent_3==1 & parent_4==1 & parent_5==0)
	replace tip_hog=7  if (parent_1==1 & parent_2==0 & parent_3==0 & parent_4==1 & parent_5==0)
	
	replace tip_hog=8  if (parent_1==1 & parent_2==1 & parent_3==0 & parent_4==0 & parent_5==1)
	replace tip_hog=9  if (parent_1==1 & parent_2==1 & parent_3==1 & parent_4==0 & parent_5==1)
	replace tip_hog=10 if (parent_1==1 & parent_2==0 & parent_3==1 & parent_4==0 & parent_5==1)
	replace tip_hog=11 if (parent_1==1 & parent_2==1 & parent_3==0 & parent_4==1 & parent_5==1)
	replace tip_hog=12 if (parent_1==1 & parent_2==1 & parent_3==1 & parent_4==1 & parent_5==1)
	replace tip_hog=13 if (parent_1==1 & parent_2==0 & parent_3==1 & parent_4==1 & parent_5==1)
	replace tip_hog=14 if (parent_1==1 & parent_2==0 & parent_3==0 & parent_4==1 & parent_5==1)
	
	replace tip_hog=15 if (parent_1==1 & parent_2==0 & parent_3==0 & parent_4==0 & parent_5==0)
	replace tip_hog=16 if (parent_1==1 & parent_2==0 & parent_3==0 & parent_4==0 & parent_5==1)
	
	gen tip_hog1=(tip_hog>=1 & tip_hog<=3)
	gen tip_hog2=(tip_hog>=4 & tip_hog<=7)
	gen tip_hog3=(tip_hog>=8 & tip_hog<=14)
	gen tip_hog4=(tip_hog==15)
	gen tip_hog5=(tip_hog==16)
	
	label var tip_hog1 "Hogar nuclear"
	label var tip_hog2 "Hogar extendido"
	label var tip_hog3 "Hogar compuesto"
	label var tip_hog4 "Hogar unipersonal"
	label var tip_hog5 "Hogar sin núcleo"
	
	label values tip_hog* dummy 
	drop parent-tip_hog	xtamhog
	
	*** Grupos de edad	
	gen xged1=(p208a<=12)
	gen xged2=(p208a<=14)
	gen xged3=(p208a>=65)
	gen xged4=(p208a>=15)
	gen xged5=(p208a>=15 & p207==1)
	gen xged6=(p208a>=15 & p207==2)
	gen xged7=(p208a>=18)
	gen xged8=(p208a>=15 & p208a<=64)	
	gen xged9=(p208a>=18 & p208a<=64)
	gen xged10=(p208a<=5)
	gen xged11=(p208a>=6 & p208a<=9)
	gen xged12=(p208a>=10 & p208a<=13)
	gen xged13=(p208a>=14 & p208a<=17)
	gen xged14=(p208a>=18 & p208a<=24)
	gen xged15=(p208a>=25 & p208a<=64)
	gen xged16=(p208a>=65 & p208a<=70)
	gen xged17=(p208a>70)
	gen xged18=(p208a>=14 & p208a<=29)
	gen xged19=(p208a==13 | p208a==14)
	gen xged20=(p208a>=10 & p208a<=12)
	gen xged21=(p208a>=15 & p208a<=17)
	
	local i=1
	while `i'<=21 {
		bysort idhogar: egen xxged`i'=sum(xged`i')
		gen pged`i'=xxged`i'/tamhog
		
		if `i'==1 {
			rename pged`i' prat0012
			label var prat0012	"Ratio de miembros del hogar <=12 años de edad"
			}
		else if `i'==2 {
			rename pged`i' prat0014
			label var prat0014	"Ratio de miembros del hogar <=14 años de edad"
			}
		else if `i'==3 {
			rename pged`i' prat6599
			label var prat6599	"Ratio de miembros del hogar de 65+ años de edad años de edad"
			}
		else if `i'==4 {
			rename pged`i' prat1599
			label var prat1599 "Ratio de miembros del hogar de 15+ años de edad"
			}
		else if `i'==5 {
			rename pged`i' prat1599h
			label var prat1599h "Ratio de hombres miembros del hogar de 15+ años de edad"
			}
		else if `i'==6 {
			rename pged`i' prat1599m
			label var prat1599m "Ratio de mujeres miembros del hogar de 15+ años de edad"
			}
		else if `i'==7 {
			rename pged`i' prat1899
			label var prat1899 "Ratio de miembros del hogar de 18+ años de edad"
			}
		else if `i'==8 {
			rename pged`i' prat1564
			label var prat1564	"Ratio de miembros del hogar de 15-64 años de edad"
			}
		else if `i'==9 {
			rename pged`i' prat1864
			label var prat1864	"Ratio de miembros del hogar de 18-64 años de edaad"
			}
		else if `i'==10 {
			rename pged`i' prat0005
			label var prat0005	"Ratio de miembros del hogar de menores de 5 años de edaad"
			}
		else if `i'==11 {
			rename pged`i' prat0609
			label var prat0609	"Ratio de miembros del hogar de 6-9 años de edaad"
			}
		else if `i'==12 {
			rename pged`i' prat1013
			label var prat1013	"Ratio de miembros del hogar de 10-13 años de edaad"
			}
		else if `i'==13 {
			rename pged`i' prat1417
			label var prat1417	"Ratio de miembros del hogar de 14-17 años de edaad"
			}
		else if `i'==14 {
			rename pged`i' prat1824
			label var prat1824	"Ratio de miembros del hogar de 18-24 años de edaad"
			}
		else if `i'==15 {
			rename pged`i' prat2564
			label var prat2564	"Ratio de miembros del hogar de 25-64 años de edaad"
			}
		else if `i'==16 {
			rename pged`i' prat6570
			label var prat6570	"Ratio de miembros del hogar de 65-70 años de edaad"
			}
		else if `i'==17 {
			rename pged`i' prat7199
			label var prat7199	"Ratio de miembros del hogar de 70+ años de edaad"
			}
		else if `i'==18 {
			rename xxged`i' xxpob1429
			}
		else if `i'==19 {
			rename pged`i' prat1314
			label var prat1314	"Ratio de miembros del hogar de 13-14 años de edaad"
			}
		else if `i'==20 {
			rename pged`i' prat1012
			label var prat1012	"Ratio de miembros del hogar de 10-12 años de edaad"
			}
		else if `i'==21 {
			rename pged`i' prat1517
			label var prat1517	"Ratio de miembros del hogar de 15-17 años de edaad"
			}
		local i=`i'+1
	}
	
	
	*** Ratios de población	
	gen prattam1=(xxged1+xxged3)/tamhog
	gen prattam2=(xxged2+xxged3)/xxged8
	recode prattam2 (.=0)
	
	label var prattam1 "Ratio de miembros (0-12 años y 65+)/tamaño del hogar"
	label var prattam2 "Ratio de miembros (0-14 años y 65+)/15-64 años"
	
*** Save dataset
	save "${data_int}/enaho_19_pop.dta", replace 