// Figures for SP Covet Paper

// Figure 1
use "${dir}/data/constructed/sp-covet.dta" , clear

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 1 ///
    , over(case) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang ///
      title("Patna") barc(red gray) bar pct ///
      legend(order(1 "Standard TB Case" 2 "Covid-Like Case")) vce(cluster uid)

  graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 2 ///
    , over(case) legend(on) xlab(${pct}) xoverhang title("Mumbai") ///
      barc(red gray) bar pct vce(cluster uid)

  graph save "${dir}/output/temp/bar-mumbai.gph" , replace

  grc1leg ///
    "${dir}/output/temp/bar-patna.gph" ///
    "${dir}/output/temp/bar-mumbai.gph"

  graph export "${dir}/output/f1-summary.pdf" , replace

// Figure 2
use "${dir}/data/constructed/sp-long.dta" , clear

  lab def round 3 "2018-19" 4 "2021-22" , replace
  lab var test_cov_ref "Covid Test"
    replace test_cov_ref = 0 if test_cov_ref == .

  betterbarci ///
    correct test_cov_ref test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    if city == 1 ///
    , over(round) legend(on pos(12) region(lw(none))) ///
      bar barc(navy%80 gray) pct xoverhang xlab(${pct}) title("Patna")

      graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cov_ref test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    if city == 2 ///
    , over(round) legend(on pos(12) region(lw(none))) ///
      bar barc(navy%80 gray) pct xoverhang xlab(${pct}) title("Mumbai")

      graph save "${dir}/output/temp/bar-mumbai.gph" , replace

  grc1leg ///
    "${dir}/output/temp/bar-patna.gph" ///
    "${dir}/output/temp/bar-mumbai.gph"

  graph export "${dir}/output/f2-rounds.pdf" , replace

// Figure 3
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  ren cov_screen screen
    lab var screen "{&darr} {bf:Covid Screening} {&darr}"
    lab var ppe "{&darr} {bf:IPC Measures} {&darr}"

  betterbarci ///
    ppe ppe_* mask_hi screen cov_* ///
    , over(city) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang ysize(7) ///
      barc(dkgreen gray) bar pct scale(0.7) vce(cluster uid) n

      graph export "${dir}/output/f3-summary.pdf" , replace

// Figure 4
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var pre_correct "100% increase in pre-Covid quality"
  ren cov_screen screen
    lab var screen "Any Screening"
    lab var ppe "Any Safety"

  forest reg ///
    (correct test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
    (ppe_* mask_hi ) ///
    (cov_*) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) cl(uid) ///
    graph(scale(0.7) ysize(7) ///
          legend(on c(1) ring(0) pos(1) ///
                 order(0 "[F1] Technical Quality" 0 "[F2] IPC Measures" 0 "[F3] Covid Screening")) ///
          xlab(0 "Zero" -.2 "-20p.p." .2 "+20p.p." .4 "+40p.p." .6 "+60p.p."))

    graph export "${dir}/output/f4-impacts.pdf" , replace


// End
