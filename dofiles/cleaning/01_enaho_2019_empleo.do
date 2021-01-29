*** Load data
use "${enaho_2019}/enaho01a-2019-500.dta", clear

* Estrato
	recode estrato (1/5=1 "urbana") (6/8=2 "rural"), gen(area)
	gen urbano = (area==1) if !missing(area)
	label var urbano "Area of residency: urban"
	
* Sexo
	gen sex = (p207 == 1)
	label define sex 1"Male" 0"Female"
	label values sex sex
	label var sex "Sex"

* Edad
	gen age = p208a
	label var age "Age"
	
	
* ingresos laborales
	egen	ing_pri 	= 	rowtotal(i524a1 d529t i530a d536) if (ocu500==1) & !missing(ocu500)
	replace ing_pri 	= 	ing_pri/12
	egen	ing_sec 	= 	rowtotal(i538a1 d540t i541a d543) if (ocu500==1) & !missing(ocu500)
	replace	ing_sec 	= 	ing_sec/12
	egen 	ing_tot_lab = 	rowtotal(ing_pri ing_sec) 
	replace ing_tot_lab = . if (ing_tot_lab==0) & (ocu500==1)
	gen 	ing_ext		= 	(d544t) if (ocu500==1) & !missing(ocu500) 
	replace ing_ext 	= 	ing_ext/12
	egen 	ingreso 	=	rowtotal(ing_tot_lab ing_ext) if (ocu500==1) & !missing(ocu500)
	replace ingreso 	= . if ingreso==0	
	
*RAMA DE ACTIVIDAD (CIIU V.4)

generate div = trunc( p506r4/100)
recode div (1/3 =1) (5/9 =2) (10/33 =3) (35 =4) (36/39 =5) (41/43 =6) (45/47 =7) (49/53 =8) (55/56 =9) (58/63 =10) (64/66 =11) (68 =12) (69/75 =13) (77/82 =14) (84 =15) (85 =16)(86/88 =17) (90/93 =18) (94/96 =19) (97/98 =20) (99 =21), gen(secc)
label define secc 1"Agropecuario y Pesca" 2"Mineria" 3"Manufactura" 4"Suministro Elect, gas, vapor" 5"Suministro Agua, residuos, desechos" 6"Construcción" 7"Comercio" 8"Transporte y Alamacenamiento" 9"Alojamiento y Serv. Comidas" 10"Infor. y Comunicaciones" 11"Financieras, Seguros" 12"Inmobiliarias" 13"Profesionales, Cientificas, Tecnicas" 14"Serv. Admin. y de Apoyo" 15"Adm. Pub, Defensa y SS" 16"Enseñanza" 17"Atencion Salud humana" 18"Serv. Artisticos, culturales, etc" 19"Asoc. y Serv. Personales" 20"Serv. de los Hogares" 21"Serv. Org. Internac"
label val secc secc
lab var secc "Actividad Economica - Seccion"

**OCHO CATEGORIAS
recode secc (1/2=.) (3=4) (4=8) (5=8) (6=5) (7=6) (8=7) (10=7) (9=8) (11/21=8), gen(nrama_pri)
replace nrama_pri = 1 if  (div == 1 | div == 2) & nrama_pri == .
replace nrama_pri = 2 if  div == 3 & nrama_pri == .
replace nrama_pri = 3 if  (div == 5 | div == 6 | div == 7 | div == 8 |div == 9) & nrama_pri == .
lab define nrama_pri 1"Agricultura" 2"Pesca" 3"Mineria" 4"Manufactura" 5"Construcción" 6"Comercio" 7"Transp y Comunic" 8"Servicios"
label val nrama_pri nrama_pri
lab var nrama_pri "Nivel por grupos de actividad Principal"
		
		
* Grupo de Edad

recode p208a (14/17=1) (18/29=2) (30/45=3) (46/60=4) (61/99=5), gen (g_edad)
lab def g_edad 1 "De 14 a 17 años" 2 "18 a 29 años" 3 "30 a 45 años" 4 "46 a 60 años" 5 "Más de 60 años"
lab val g_edad g_edad		



*** Save dataset
	save "${data_int}/enaho_05_emp.dta", replace 	