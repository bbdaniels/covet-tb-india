// Figures for SP Covet Paper

// Figure 1

use "${dir}/data/constructed/sp-long.dta" if round == 3, clear
  append using "${dir}/data/constructed/sp-covet.dta"

  gen type = 0
    replace type = 1 if round == 4
    replace type = 2 if case == 9

    replace test_cov = 0 if test_cov == .

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 1 ///
    , over(type) ///
      xlab(${pct}) xoverhang ///
      title("Patna") barc(navy%80 red gray) bar pct   ///
      legend(on c(1) pos(12) region(lc(none)) ///
             order(1 "Standard TB Case Presentation, 2018-19" ///
                   2 "Standard TB Case Presentation, 2021-22" ///
                   3 "Less-Specific TB Case Presentation, 2021-22"))

  graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 2 ///
    , over(type) ///
      xlab(${pct}) xoverhang ///
      title("Mumbai") barc(navy%80 red gray) bar pct   ///
      legend(on pos(12) region(lc(none)) ///
             order(1 "Standard TB Case Presentation, 2018-19" ///
                   2 "Standard TB Case Presentation, 2021-22" ///
                   3 "Less-Specific TB Case Presentation, 2021-22"))

  graph save "${dir}/output/temp/bar-mumbai.gph" , replace

  grc1leg ///
    "${dir}/output/temp/bar-patna.gph" ///
    "${dir}/output/temp/bar-mumbai.gph"

    graph draw

  graph export "${dir}/output/f1-summary.pdf" , replace

// Figure 2
  use "${dir}/data/constructed/sp-long.dta" , clear

  forest reg ///
    (correct test_cxr test_afb test_gx refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
  , t(4.round) c(i.city i.case) b bh sort(local) cl(fid) ///
    graph(ysize(7) title("Standard TB Case Presentation, 2018-19 vs 2021-22", size(medium) pos(11) span) ///
          legend(off c(1) ring(0) pos(1)) xoverhang ///
          xlab(${neg20}) xtitle("Percentage-Point Increase In 2021-22"))

    graph save "${dir}/output/temp/reg-round.gph" , replace

  use "${dir}/data/constructed/sp-covet.dta" , clear

  forest reg ///
    (correct test_cxr test_afb test_gx refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
  , t(1.case) c(i.city) b bh sort(local) cl(fid) ///
    graph(ysize(7) title("Standard vs Less-Specific TB Case Presentation, 2021-22", size(medium) pos(11) span) ///
          legend(off c(1) ring(0) pos(1)) xoverhang ///
          xlab(${neg20})  xtit("Percentage-Point Increase In Standard Presentation"))

    graph save "${dir}/output/temp/reg-case.gph" , replace

  graph combine ///
    "${dir}/output/temp/reg-round.gph" ///
    "${dir}/output/temp/reg-case.gph" ///
    , c(1) ysize(6) xcom

  graph export "${dir}/output/f2-differences.pdf" , replace

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
