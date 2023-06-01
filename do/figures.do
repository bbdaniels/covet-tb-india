// Figures for SP Covet Report

// Attrition figures

use "${dir}/data/constructed/sp-all.dta" if round > 2, clear

  egen tag = tag(city fidcode round)
    keep if tag

  egen n = group(city fidcode)
  bys city: egen no = min(n)
    replace n = n - no + 1
  bys city: egen N = max(n)

  bys city n : gen n2 = _N

  tw ///
    (scatter n round if n2 == 2 , mc(black)) ///
    (scatter n round if n2 == 1 , mc(red) m(x)) ///
    , xlab(2.5 " " 3 "2018-19" 4 "2021-22" 4.5 " " ,notick) ///
      legend(off order(1 "Matched" 2 "Unmatched")) by(city , legend(on) note(" ")) ///
      ytit("Practices Sampled in 2018-19") yline(100 200 300 , lc(gray)) ///
      ysize(6) xoverhang

      graph export "${dir}/output/qutub-sampling.pdf" , replace


// Core figures

use "${dir}/data/constructed/sp-all.dta" if case == 1 , clear

  lab var  correct "Test or Refer"

  betterbarci correct ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct}) ///
      xoverhang ysize(6) scale(0.8)

      graph export "${dir}/output/cross-correct.pdf" , replace

  betterbarci test_gx ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct20}) ///
      xoverhang ysize(6) scale(0.8)

      graph export "${dir}/output/cross-gx.pdf" , replace

  betterbarci test_cxr ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct}) ///
      xoverhang ysize(6) scale(0.8)

      graph export "${dir}/output/cross-cxr.pdf" , replace

  betterbarci test_afb ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct20} .25 "25%") ///
      xoverhang ysize(6) scale(0.8)

      graph export "${dir}/output/cross-afb.pdf" , replace

---

use "${dir}/data/constructed/sp-all.dta" if case == 1 & round > 2 , clear

  lab def round 3 "2018-19" 4 "2021-22" , modify

  betterbarci ///
      test_cxr test_afb test_gx refer ///
      med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    , over(round) n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
      bar pct xlab(${pct}) ysize(6) xoverhang

      graph export "${dir}/output/cross-r34.pdf" , replace

use "${dir}/data/constructed/sp-all.dta" if round == 4 , clear

  lab def case 1 "Standard" 9 "Covid-Like" , modify

  betterbarci ///
      test_cxr test_afb test_gx refer ///
      med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    , over(case) n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
      bar pct xlab(${pct}) ysize(6) xoverhang

      graph export "${dir}/output/cross-case.pdf" , replace

use "${dir}/data/constructed/sp-all.dta" if case == 1 , clear

  betterbarci med_anti_any_3 ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(maroon maroon%60 maroon%40 maroon%20) ylab(${pct})

      graph export "${dir}/output/cross-abx.pdf" , replace

  betterbarci med_anti_any_2 ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(maroon maroon%60 maroon%40 maroon%20) ylab(${pct20})

      graph export "${dir}/output/cross-fq.pdf" , replace

  betterbarci med_code_any_9 ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(maroon maroon%60 maroon%40 maroon%20) ylab(${pct20})

      graph export "${dir}/output/cross-ster.pdf" , replace

----

// End
