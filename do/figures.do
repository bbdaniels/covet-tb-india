// Figures for SP Covet Report

// Attrition figures

use "/Users/bbdaniels/Library/CloudStorage/Box-Box/_Papers/SP Patna/data/raw/patna-samples.dta", clear
reshape long sam_ sps_ , i(fid) j(round)
gen city = 1
  tempfile pat
  save `pat'

use "/Users/bbdaniels/Library/CloudStorage/Box-Box/_Papers/SP Mumbai/data/raw/mumbai-facility-samples.dta", clear
drop if fid == ""
gen city = 2
reshape long sam_ sps_ , i(fid) j(round)
  append using `pat' , force

  lab def city 1 "Patna" 2 "Mumbai"
    lab val city city

  lab var sps_ "Sample Completion"

  betterbarci sps_ if (sam_ == 1 & round > 1) | (sps_ == 1 & round == 1) ///
  , over(round) by(city) v pct bar barc(dkgreen%70 dkgreen%80 dkgreen%90 dkgreen) ///
    legend(on order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ylab(${pct})

    graph export "${dir}/output/qutub-attrition.pdf" , replace



// Study 1: All things

  // IPC and Screening
  use "${dir}/data/constructed/sp-covet.dta" , clear

  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  egen symscreen = rowmax(cov_6 cov_7 cov_8 cov_9 cov_10 cov_11 cov_12 cov_13 cov_14 cov_15 cov_16)
    lab var symscreen "Ask About Symptoms"

  ren cov_screen screen
    lab var screen "{&darr} {bf:Covid Screening} {&darr}"
    lab var ppe "{&darr} {bf:IPC Measures} {&darr}"

  betterbarci ///
    ppe ppe_3 mask_hi ppe_1 ppe_2 ppe_5 ppe_7 ppe_8 ///
    screen cov_1-cov_5 symscreen ///
    , over(city) legend(on symxsize(small) pos(12) region(lc(none))) xlab(${pct}) ///
      xoverhang ysize(7) ///
      bar pct vce(cluster uid) n

      graph export "${dir}/output/ipc-screen.pdf" , replace

  // Qutub summary

  use "${dir}/data/constructed/sp-combined.dta" ///
    if round < 4 & case < 5 , clear

    lab var correct "Correct"

    betterbarci ///
        correct test_cxr test_afb test_gx refer ///
        med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
      , over(city) n ///
        legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
        bar pct xlab(${pct}) ysize(6) xoverhang

        graph export "${dir}/output/qutub-summary.pdf" , replace

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

    egen test_cov = rowmax(test_cov*)
    lab var test_cov "Covid Test"

    betterbarci ///
        test_cov test_cxr test_afb test_gx refer ///
        med_anti_any_1 med_anti_any_3 med_anti_any_2 med_code_any_9 ///
      , over(case) n ///
        legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ) ///
        bar pct xlab(${pct}) ysize(6) xoverhang

        graph export "${dir}/output/cross-case.pdf" , replace

// Study 1: Good things
use "${dir}/data/constructed/sp-all.dta" if case == 1 , clear

  gen microbio = test_afb == 1 | test_gx == 1
    lab var microbio "Microbiology"

  betterbarci microbio ///
    , over(round) by(city) v n ///
      legend(on region(lw(none)) symxsize(small) r(1) pos(6) ring(1) ///
            order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022")) ///
      bar pct barc(navy navy%60 navy%40 navy%20) ylab(${pct20}) ///
      xoverhang

      graph export "${dir}/output/cross-mb.pdf" , replace

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

// Prices
use "${dir}/data/constructed/sp-all.dta" if case == 1 , clear

  gen p2 = .
  replace p2 = price / 65 if round == 1
  replace p2 = price / 65 if round == 2
  replace p2 = price / 70 if round == 3
  replace p2 = price / 80 if round == 4

  lab var p2 "Price (USD)"
  lab var price "Price (INR)"

  betterbarci p2 ///
  , over(round) by(city) v bar ///
    barc(dkgreen dkgreen%80 dkgreen%60 dkgreen%40)

    graph save "${dir}/output/price-usd.gph" , replace

  betterbarci price ///
  , over(round) by(city) v bar ///
    barc(dkgreen dkgreen%80 dkgreen%60 dkgreen%40) ///
    legend(on order(1 "2014-2015" 2 "2016-2017" 3 "2018-2019" 4 "2021-2022"))

    graph save "${dir}/output/price-inr.gph" , replace

    grc1leg  ///
      "${dir}/output/price-inr.gph" ///
      "${dir}/output/price-usd.gph" ///
      , c(1)

      graph draw, ysize(6)

      graph export "${dir}/output/price.pdf" , replace

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
use "${dir}/data/constructed/sp-covet.dta" , clear

  forest reg (test_cov) (cov_*) , t(pre_correct) c(i.city i.case) b bh cl(fid) sort(local) ///
    graph(xoverhang xlab(${pct20}) ///
          xtit("{&larr} Less | {bf:Covid Testing and Screening} | More {&rarr}"))


    graph export "${dir}/output/long-screen.pdf" , replace

  forest reg (ppe_*) , t(pre_correct) c(i.city i.case) b bh cl(fid) sort(local) ///
    graph(xoverhang xlab(${pct75}) ///
         xtit("{&larr} Less | {bf:IPC Measures} | More {&rarr}"))

    graph export "${dir}/output/long-ipc.pdf" , replace

// Study 2: Longitudinal
use "${dir}/data/constructed/sp-all.dta"  , clear

  gen r3 = round == 3
  gen r4 = round == 4

  labelcollapse (mean) correct test_afb test_cxr test_gx ///
                  med_anti_any_3 med_anti_any_2 med_code_any_9 ///
           (max) r3 r4, by(city fidcode)

  lab var correct "TB Test or Refer"
  lab var r4 "Appeared in Round 4 (Non-Attriting)"

  forest reg (correct test_afb test_cxr test_gx ///
              med_anti_any_3 med_anti_any_2 med_code_any_9) ///
        , t(r4) b bh sort(local) ///
         graph(xoverhang xlab(${pct20}) ///
               xtit("{&larr} More | {bf:Attrition} | Less {&rarr}"))

        graph export "${dir}/output/long-attrit.pdf" , replace

// End
