
clear
gen meshid=""
cd D:\Research\Projects\StemCells\StemCells2\Data
tempfile stemcellcore
save `stemcellcore', replace

cd B:\Research\RAWDATA\MeSH\2016\Parsed
import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
tempfile hold1
replace mesh=lower(mesh)
gen stemcell=0
replace stemcell=1 if regexm(mesh, "stem cell")
keep if stemcell==1
keep treenumber
duplicates drop

set more off
levelsof treenumber, local(levels) 
foreach l of local levels {
	
	cd B:\Research\RAWDATA\MeSH\2016\Parsed
	import delimited "desc2016_meshtreenumbers.txt", clear delimiter(tab) varnames(1)
	keep if regexm(treenumber, "`l'")
	
	cd D:\Research\Projects\StemCells\StemCells2\Data
	append using `stemcellcore'
	save `stemcellcore', replace
 }
 
keep mesh
replace mesh=lower(mesh)
duplicates drop
* Make all words singular
gen mesh2=regexs(1) if regexm(mesh, "(.*)s$") 
replace mesh2=mesh if mesh2==""
drop mesh
rename mesh2 mesh

sort mesh
cd D:\Research\Projects\StemCells\StemCells2\Data
export delimited using "stemcellcoremeshterms.txt", delimiter(tab) novarnames replace
