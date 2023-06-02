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

// Study 1: All things

  // IPC and Screening
  use "${dir}/data/constructed/sp-covet.dta" , clear

  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  ren cov_screen screen
    lab var screen "{&darr} {bf:Covid Screening} {&darr}"
    lab var ppe "{&darr} {bf:IPC Measures} {&darr}"

  betterbarci ///
    ppe ppe_* mask_hi screen cov_* ///
    , over(city) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang ysize(7) ///
      bar pct scale(0.7) vce(cluster uid) n

      graph export "${dir}/output/ipc-screen.pdf" , replace

  // Key behaviors by round
  use "${dir}/data/constructed/sp-all.dta" if case == 1 & round > 2 , clear

    lab def round 3 "2018-19" 4 "2021-22" , modify

  betterbarci ///
      test_cxr test_afb test_gx refer ///
      med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    , over(round) n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
      bar pct xlab(${pct}) ysize(6) xoverhang

      graph export "${dir}/output/cross-r34.pdf" , replace

  // Key behaviors by case
  use "${dir}/data/constructed/sp-all.dta" if round == 4 , clear

    lab def case 1 "Standard" 9 "Covid-Like" , modify

    betterbarci ///
        test_cxr test_afb test_gx refer ///
        med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
      , over(case) n ///
        legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
        bar pct xlab(${pct}) ysize(6) xoverhang

        graph export "${dir}/output/cross-case.pdf" , replace

// Study 1: Good things
use "${dir}/data/constructed/sp-all.dta" if case == 1 , clear

  lab var  correct "Test or Refer"

  betterbarci test_gx ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct20}) ///
      xoverhang

      graph export "${dir}/output/cross-gx.pdf" , replace

  betterbarci test_cxr ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct}) ///
      xoverhang

      graph export "${dir}/output/cross-cxr.pdf" , replace

  betterbarci test_afb ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct20} .25 "25%") ///
      xoverhang

      graph export "${dir}/output/cross-afb.pdf" , replace

// Study 1: Bad things
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

// Study 2: Longitudinal
use "${dir}/data/constructed/sp-all.dta" if round < 4 & case == 1 , clear

  keep correct city fid round test_*

  collapse (mean) c = correct a = test_afb x = test_cxr g = test_gx , by(city fid)

  merge 1:m city fid using "${dir}/data/constructed/sp-all.dta" , keep(3) nogen
    keep if round == 4 & case == 1

  tw (fpfit correct c , lw(thick)) ///
     (fpfit test_afb a , lw(thick)) ///
     (fpfit test_gx g , lw(thick)) ///
     (fpfit test_cxr x , lw(thick)) ///
  , legend(on c(1) pos(11) ring(0) ///
           order(1 "TB Test or Refer" 4 "Chest X-Ray" ///
                 3 "GeneXpert" 2 "Sputum AFB" )) ///
    xlab(${pct}) ylab(${pct}) xtit("Pre-Covid") ytit("Post-Covid") xoverhang

    graph export "${dir}/output/long-good.pdf" , replace

use "${dir}/data/constructed/sp-all.dta" if round < 4 & case == 1 , clear

  keep correct city fid round med_anti_any_3 med_anti_any_2 med_code_any_9

  collapse (mean) abx = med_anti_any_3 fq = med_anti_any_2 ster = med_code_any_9 , by(city fid)

  merge 1:m city fid using "${dir}/data/constructed/sp-all.dta" , keep(3) nogen
    keep if round == 4 & case == 1

  tw ///
     (fpfit med_anti_any_3 abx , lw(thick)) ///
     (fpfit med_anti_any_2 fq , lw(thick)) ///
     (fpfit med_code_any_9 ster , lw(thick)) ///
  , legend(on c(1) pos(11) ring(0) ///
           order(1 "Antibiotics"  ///
                 3 "Steroids" 2 "Fluoroquinolones" )) ///
    xlab(${pct}) ylab(${pct}) xtit("Pre-Covid") ytit("Post-Covid") xoverhang

    graph export "${dir}/output/long-bad.pdf" , replace

// Study 2: Longitudinal
use "${dir}/data/constructed/sp-all.dta"  , clear

  gen r3 = round == 3
  gen r4 = round == 4

  labelcollapse (mean) correct test_afb test_cxr test_gx ///
                  med_anti_any_3 med_anti_any_2 med_code_any_9 ///
           (max) r3 r4, by(city fidcode)

  lab var correct "TB Test or Refer"
  lab var r4 "Appeared in Round 4 (Non-Attriting)"
    replace r4 = 1-r4

  forest reg (correct test_afb test_cxr test_gx ///
              med_anti_any_3 med_anti_any_2 med_code_any_9) ///
        , t(r4) b bh sort(local) graph(xtit("Association with Attrition"))

        graph export "${dir}/output/long-attrit.pdf" , replace

// End
