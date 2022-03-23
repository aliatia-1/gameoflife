*! gameoflife, v3 (03.22.2022), Ali Atia, alitarekatia@gmail.com
*===============================================================================
* Program: gameoflife
* Update: Expanded functionality and improved efficiency
* Author:  Ali Atia
* Version: 3 (03.22.2022)
*===============================================================================

program define gameoflife
	quietly{
		preserve
		syntax, Time(integer) Visualize(str) Dimensions(integer) border(str) [Input(str) Export(str) name(str) switchat(numlist max=1) switchto(str)]
		
		if !inlist("`visualize'","plot","twoway","none") | !inlist(`"`switchto'"',"plot","twoway","none",""){
			noisily di as error "Incorrect visualization format specified."
			exit
		}
		if !inlist("`border'","dead","infinite","wrap"){
			noisily di as error "Incorrect border-type specified."
			exit
		}
		if ("`switchat'"=="" & "`switchto'"!="") | ("`switchat'"!="" & "`switchto'"==""){
			noisily di as error "Switchat() and switchto() must be specified together."
			exit
		}
		
		local type = substr("`input'",strlen("`input'")-2,3)
		
		if !inlist("`type'","csv","dta",""){
			noisily di as error "Incorrect input filetype specified."
			exit
		}

		if `"`border'"'=="dead" local dimensions = `dimensions'+2 
		
		if `"`input'"'==""{
			clear
			set obs `=(`dimensions'+1)^2'
			egen dimx = seq(),f(0) t(`=`dimensions'') b(`=`dimensions'+1')
			egen dimy = seq(),f(0) t(`=`dimensions'')
			gen self = strofreal(dimx) + " " + strofreal(dimy)
			gen alive = runiformint(0,1)
		}
		
		if `"`type'"'!="dta"{
			if `"`type'"'=="csv"{				
				clear
				import delimited `"`input'"',clear
				foreach v of varlist *{
					cap replace `v'="0" if `v'=="*"
					cap destring `v', force replace
					replace `v' = `v'!=.
				}
				rename * v#, renumber
				ds
				if (`=_N'>`dimensions') | (`:word count `r(varlist)''>`dimensions') local dimensions = max(`=_N',`:word count `r(varlist)'')
				local amountrows = ceil((`dimensions'-`=_N')/2)
				local last =subinstr("`:word `:word count `r(varlist)'' of `r(varlist)''","v","",.)
				local amountcols = ceil((`dimensions'-`:word count `r(varlist)'')/2)
				insobs `amountrows',after(`=_N')
				insobs `amountrows',before(1)
				foreach v of varlist *{
					replace `v' = 0 if `v'==.
				}
				rename v# v#, renumber(`=`amountcols'+1')
				forval x = 1/`amountcols'{
					gen v`x' = 0
					gen v`=`last'+`amountcols'+`x'' = 0
				}
				order *, seq
				rename v* y*
				forval x = 1/`dimensions'{
					if "`type'"=="txt" gen y`x' = x`x'==" "
					gen new`x' = _n if y`x'
					levelsof new`x', local(alive`x')
					if "`alive`x''"!=""{ 
						local listy `listy' (dimx == `x' &
						forval y = 1/`:word count `alive`x'''{
							local newamount =`dimensions'-`:word `y' of `alive`x'''
							if `:word count `alive`x'''==1 local listy `listy' (dimy == `newamount')) |
							else if `y'==1 local listy `listy' ((dimy == `newamount') |
							else if `y'!=`:word count `alive`x''' & `y'!=1 local listy `listy' (dimy == `newamount') |
							else if `y'==`:word count `alive`x''' local listy `listy' (dimy == `newamount'))) |
						}
					}
				}
				
				local listy = substr("`listy'",1,strlen("`listy'")-1)
				keep y*
				set obs `=(`dimensions'+1)^2'
				egen dimx = seq(),f(0) t(`dimensions') b(`=`dimensions'+1')
				egen dimy = seq(),f(0) t(`dimensions')
				gen self = strofreal(dimx) + " " +strofreal(dimy)
				gen alive = `listy'
				drop y*
			}

			if `"`border'"'=="dead" replace alive = 0 if dimy>=`dimensions' | dimy<=0 | dimx<=0 | dimx>=`dimensions'
				
			expand 9, gen(expand)
			
			bys self: replace expand = _n
			
			gen a1 = "0 0 1 1 1 0 -1 -1 -1"
			gen a2 = "0 1 1 0 -1 -1 -1 0 1"
			
			if `"`border'"'=="wrap" gen neighbor = strofreal(mod(dimx + real(word(a1,expand)),`=`dimensions'+1')) + " " + strofreal(mod(dimy + real(word(a2,expand)),`=`dimensions'+1'))
			else gen neighbor = strofreal(dimx + real(word(a1,expand))) + " " + strofreal(dimy + real(word(a2,expand)))
			
			replace alive = 500 if neighbor==self & alive==1
		}
		
		else if "`type'"=="dta"{
		    use `"`input'"', clear
		}
		
		if `"`export'"'!=""{
			save "`export'", replace
		}
		
		foreach i in x y{
			local `i'max `dimensions'
			local `i'min 0
		}
		
		if `"`border'"'=="infinite" local size_option msize(vsmall)
		
		if "`visualize'"=="twoway"{
			twoway scatter dimy dimx if alive, mcolor(black) `size_option'||, name(time0,replace)  ysc(r(0 `dimensions') off) xsc(r(0 `dimensions') off) xtitle("") ytitle("") graphregion(margin(zero) color(white)) legend(off) yla(,nogrid) plotregion(lcolor(black))
			if `"`export'"'!="" gr export "`export'_`:di %0`=strlen("`time'")'.0f 0'.png", as(png) replace width(1080) height(1080)
			gr drop time0
		}
			
		if "`visualize'"=="plot" noisily plot dimy dimx if alive
		
		forval x = 1/`time'{
			
			if "`switchat'"!=""{
				if `x'==`switchat' local visualize `"`switchto'"'
			}
			
			replace alive = 500 if neighbor==self & alive==1
			
			keep if alive!=0
			collapse (sum) howmanyalive=alive, by(neighbor)
			keep if inlist(howmanyalive,502,503,2,3)
			generate alive = howmanyalive>500
			
			rename neighbor self
			
			gen neighbor=""
			
			gen dimx = real(word(self,1))
			gen dimy = real(word(self,2))
			
			expand 9, gen(expand)
			
			bys self: replace expand = _n
			
			gen a1 = "0 0 1 1 1 0 -1 -1 -1"
			gen a2 = "0 1 1 0 -1 -1 -1 0 1"
			
			if `"`border'"'=="wrap" replace neighbor = strofreal(mod(dimx + real(word(a1,expand)),`=`dimensions'+1')) + " " + strofreal(mod(dimy + real(word(a2,expand)),`=`dimensions'+1'))
			else replace neighbor = strofreal(dimx + real(word(a1,expand))) + " " + strofreal(dimy + real(word(a2,expand)))
			
			replace alive = (alive==1 & inlist(howmanyalive,2,3,502,503)) | (alive==0 & inlist(howmanyalive,3,503))
			
			drop howmanyalive
			
			if "`border'"=="dead" replace alive = 0 if inlist(0,dimy,dimx) | inlist(`dimensions',dimy,dimx)
			
			if "`border'"=="infinite" & "`visualize'"=="twoway"{
				foreach i in x y{
					sum dim`i'
					if r(max) > ``i'max' local `i'max = r(max)
					if r(min) < ``i'min' local `i'min = r(min)
				}
			}
			
			if "`visualize'"=="twoway"{
				twoway scatter dimy dimx if alive,  mcolor(black) `size_option'||, name(time`x',replace) ysc(r(`ymin' `ymax') off) xsc(r(`xmin' `xmax') off)  xlabel(`xmin'(1)`xmax') yla(`ymin'(1)`ymax') xtitle("") ytitle("") graphregion(margin(zero)  color(white)) legend(off) yla(,nogrid)  plotregion(lcolor(black))
				if `"`export'"'!="" gr export "`export'_`:di %0`=strlen("`time'")'.0f `x''.png", as(png) replace width(1080) height(1080) 
				graph drop time`x'
			}
			
			else if "`visualize'"=="plot" noisily plot dimy dimx if alive
			noisily di `x'
		}
	}
end
