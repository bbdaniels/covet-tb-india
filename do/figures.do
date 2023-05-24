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
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  ren cov_screen screen
    lab var screen "{&darr} {bf:Covid Screening} {&darr}"
    lab var ppe "{&darr} {bf:IPC Measures} {&darr}"

  betterbarci ///
    ppe ppe_* mask_hi screen cov_* ///
    , over(city) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang ysize(7) ///
      barc(red gray) bar pct scale(0.7) vce(cluster uid)

      graph export "${dir}/output/f2-summary.pdf" , replace

// Figure 3
use "${dir}/data/constructed/sp-long.dta" , clear

  lab def round 3 "2018-19" 4 "2020-21" , replace

  betterbarci ///
    correct test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    if city == 1 ///
    , over(round) legend(on pos(12) region(lw(none))) ///
      bar barc(navy%80 gray) pct xoverhang xlab(${pct}) title("Patna")

      graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
    if city == 2 ///
    , over(round) legend(on pos(12) region(lw(none))) ///
      bar barc(navy%80 gray) pct xoverhang xlab(${pct}) title("Mumbai")

      graph save "${dir}/output/temp/bar-mumbai.gph" , replace

  grc1leg ///
    "${dir}/output/temp/bar-patna.gph" ///
    "${dir}/output/temp/bar-mumbai.gph"

  graph export "${dir}/output/f3-rounds.pdf" , replace

// Figure 4
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var pre_correct "100% increase in prior quality"
  ren cov_screen screen
    lab var screen "Any Screening"
    lab var ppe "Any Safety"

  forest reg ///
    (ppe ppe_* mask_hi ) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) cl(uid) ///
    graph(ysize(5) title("IPC Measures" , span pos(11)) ///
          xlab(0 "Zero" .1 "+10p.p." .2 "+20p.p." .3 "+30p.p."))

    graph save "${dir}/output/temp/for-ppe.gph" , replace

  forest reg ///
    (screen cov_*) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) cl(uid) ///
    graph(ysize(5) title("Covid Screening" , span pos(11)) ///
          xlab(0 "Zero" .1 "+10p.p." .2 "+20p.p." .3 "+30p.p."))

    graph save "${dir}/output/temp/for-screen.gph" , replace

  forest reg ///
    (correct test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) cl(uid) ///
    graph(ysize(5) title("Quality of TB Care" , span pos(11)) ///
          xlab(0 "Zero" -.2 "-20p.p." .2 "+20p.p." .4 "+40p.p." .6 "+60p.p."))


    graph save "${dir}/output/temp/for-qual.gph" , replace

    graph combine ///
    "${dir}/output/temp/for-qual.gph" ///
    "${dir}/output/temp/for-ppe.gph" ///
    "${dir}/output/temp/for-screen.gph" ///
    , c(1) ysize(7) imargin(tiny) altshrink

    graph export "${dir}/output/f4-impacts.pdf" , replace


// End
