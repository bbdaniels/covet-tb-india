// Figures for SP Covet Paper

// Figure 1
use "${dir}/data/constructed/sp-covet.dta" , clear

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 1 ///
    , over(case) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang title("Patna") barc(red gray) bar pct ///
      legend(order(1 "Standard TB Case" 2 "Covid-Like Case"))

  graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 2 ///
    , over(case) legend(on) xlab(${pct}) xoverhang title("Mumbai") barc(red gray) bar pct

  graph save "${dir}/output/temp/bar-mumbai.gph" , replace

  grc1leg ///
    "${dir}/output/temp/bar-patna.gph" ///
    "${dir}/output/temp/bar-mumbai.gph"

  graph export "${dir}/output/f1-summary.pdf" , replace

// Figure 2
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  ren cov_screen screen
    lab var screen "Any Screening"
    lab var ppe "Any Safety"

  betterbarci ///
    ppe ppe_* mask_hi screen cov_* ///
    , over(case) legend(on pos(12) region(lc(none))) xlab(${pct}) xoverhang ysize(7) ///
      barc(red gray) bar pct scale(0.7)

      graph export "${dir}/output/f2-summary.pdf" , replace


// Figure 3
use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(uid)
  lab def case 1 "Standard TB Case" 9 "Covid-Like Case" , replace

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess correct   pre_correct  if city == 1 , lc(black%50) lp(dash)) ///
    (lowess correct   pre_correct  if city == 2 , lc(black%50) lp(dash)) ///
    (lowess correct   pre_correct  , lc(black) lw(thick)) ///
    (lowess test_cov  pre_correct  if city == 1 , lc(blue%50) lp(dash)) ///
    (lowess test_cov  pre_correct  if city == 2 , lc(blue%50) lp(dash)) ///
    (lowess test_cov  pre_correct   , lc(blue) lw(thick) ) ///
  , ${hist_opts} by(case , ixaxes c(1) legend(on order(2 "Patna" 3 "Mumbai")) imargin(medium) note("")) ysize(7) ///
    legend(off order(4 "TB Test or Refer" 3 "Cities Separate" 7 "Covid Test" 6 "Cities Separate") ///
      pos(12) c(2) region(lc(none))) ///
    xlab(.25 "25%" .5 "50%" .75 "75%" 1 "100%" 0 "Prior Quality {&rarr}") xoverhang ///
    ylab(${pct}) ytit("") xtit("") yscale(noline) ylab(none, axis(2))

    graph export "${dir}/output/f3-testing.pdf" , replace

// Figure 4
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var pre_correct "100% increase in prior quality"
  ren cov_screen screen
    lab var screen "Any Screening"
    lab var ppe "Any Safety"

  forest reg ///
    (ppe ppe_* mask_hi ) (screen cov_*) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) ///
    graph(ysize(5) scale(0.7)  title("Safety (F1) and Screening (F2)" , span pos(11)) ///
          xlab(0 "Zero" .1 "+10p.p." .2 "+20p.p." .3 "+30p.p."))

    graph save "${dir}/output/temp/for-ppe.gph" , replace

  forest reg ///
    (correct test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) ///
    graph(ysize(5) title("Quality of TB Care" , span pos(11)) ///
          xlab(0 "Zero" -.2 "-20p.p." .2 "+20p.p." .4 "+40p.p."))


    graph save "${dir}/output/temp/for-qual.gph" , replace

    graph combine ///
    "${dir}/output/temp/for-qual.gph" ///
    "${dir}/output/temp/for-ppe.gph" ///
    , c(1) ysize(7)

    graph export "${dir}/output/f4-impacts.pdf" , replace


// End
