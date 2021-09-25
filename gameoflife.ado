program define gameoflife
	quietly{
		syntax, Time(integer) Dimensions(integer) Visualize(str asis) [*]
		noisily mac li
		if !inlist("`visualize'","plot","twoway"){
			noisily di as error "Arguments for the visualize option can be plot or twoway"
			exit
		}
		preserve
		clear all
		set obs `=(`dimensions'+1)^2'
		egen time = seq(), f(0) b(`=(`dimensions'+1)^2')
		egen dimx = seq(),f(0) t(`=`dimensions'') b(`=`dimensions'+1')
		egen dimy = seq(),f(0) t(`=`dimensions'')
		gen self = strofreal(dimx) + " " + strofreal(dimy)
		gen alive = runiformint(0,1) 
		gen up = dimy==`dimensions'
		gen down = dimy==0
		gen left = dimx==0
		gen right = dimx==`dimensions'
		foreach i in up_left up_right down_left down_right{
			gen `i' = `=subinstr("`i'","_"," & ",1)'
		}
		local a `""0 1" "1 1" "1 0" "1 -1" "0 -1" "-1 -1" "-1 0" "-1 1""'
		local up `""0 -`dimensions'" "1 -`dimensions'" "1 0" "1 -1" "0 -1" "-1 -1" "-1 0" "-1 -`dimensions'""'
		local left `""0 1" "1 1" "1 0" "1 -1" "0 -1" "`dimensions' -1" "`dimensions' 0" "`dimensions' 1""'
		local down `""0 1" "1 1" "1 0" "1 `dimensions'" "0 `dimensions'" "-1 `dimensions'" "-1 0" "-1 1""'
		local right `""0 1" "`dimensions' 1" "`dimensions' 0" "`dimensions' -1" "0 -1" "-1 -1" "-1 0" "-1 1""'
		local up_left `""0 -`dimensions'" "1 -`dimensions'" "1 0" "1 -1" "0 -1" "`dimensions' -1" "`dimensions' 0" "`dimensions' -`dimensions'""'
		local up_right `""0 -`dimensions'" "`dimensions' -`dimensions'" "`dimensions' 0" "`dimensions' -1" "0 -1" "-1 -1" "-1 0" "-1 -`dimensions'""'
		local down_left `""0 1" "1 1" "1 0" "1 `dimensions'" "0 `dimensions'" "`dimensions' `dimensions'" "`dimensions' 0" "`dimensions' 1""'
		local down_right `""0 1" "`dimensions' 1" "`dimensions' 0" "`dimensions' `dimensions'" "0 `dimensions'" "-1 `dimensions'" "-1 0" "-1 1""'

		forval x = 1/8{
			gen neighbor`x' = ""
			replace neighbor`x' = strofreal(dimx + `:word 1 of `:word `x' of `a''') + " " + strofreal(dimy + `:word 2 of `:word `x' of `a''')
			foreach i in up down left right up_left up_right down_left down_right{
				replace neighbor`x' = strofreal(dimx + `:word 1 of `:word `x' of ``i'''') + " " + strofreal(dimy + `:word 2 of `:word `x' of ``i'''') if `i'
			}
		}
		reshape long neighbor, i(time dimy dimx self) j(new,string)
		keep time dimy dimx self alive neighbor
		forval x = 1/`time'{
			tempfile temp
			save `temp'
			collapse (first) alive,by(time self)
			gen neighbor = self
			gen neighboralive = alive
			rename alive alive_1
			replace time = `x'
			tempfile temp2
			save `temp2'
			use `temp',clear
			replace time = `x'
			merge m:1 time neighbor using `temp2', nogen keepusing(neighboralive)
			merge m:1 time self using `temp2', nogen keepusing(alive_1)
			bysort self: egen dimensionsalive = total(neighboralive==1)
			if "`visualize'"=="twoway" & `x'==1{
				twoway scatter dimy dimx if alive, mcolor(black) ||, name(time0,replace)  ysc(r(0 `dimensions') off) xsc(r(0 `dimensions') off) xtitle("") ytitle("") graphregion(margin(zero)) legend(off) yla(,nogrid) `options'
			}
			if "`visualize'"=="plot" & `x'==1{
			    noisily plot dimy dimx if alive `options'
			}
			replace alive = (alive_1==1 & inlist(dimensionsalive,2,3)) | (alive_1==0 & dimensionsalive==3)
			if "`visualize'"=="twoway"{
				twoway scatter dimy dimx if alive,  mcolor(black) ||, name(time`x',replace) ysc(r(0 `dimensions') off) xsc(r(0 `dimensions') off) xtitle("") ytitle("") graphregion(margin(zero)) legend(off) yla(,nogrid) `options'
			}
			if "`visualize'"=="plot"{
				noisily plot dimy dimx if alive `options'
			}
			drop neighboralive alive_1 dimensionsalive

		}
	}
end