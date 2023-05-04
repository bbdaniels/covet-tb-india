// Figures for SP Covet Paper

// Figure 1
use "${dir}/data/constructed/sp-covet.dta" , clear

  betterbarci ///
    correct test_cov test_cxr test_afb test_gx refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 1 ///
    , over(case) legend(on) xlab(${pct}) xoverhang title("Patna") barc(red gray) bar pct ///
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

  graph export "${dir}/output/summary.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(uid)
  lab def case 1 "Standard TB" 9 "Covid-Like" , replace

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess correct   pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess correct   pre_correct  if city == 2 , lc(blue)  lw(thick)) ///
  , ${hist_opts} by(case , legend(off order(2 "Patna" 3 "Mumbai")) imargin(medium) note("")) xsize(10) ///
    legend(off order(2 "Patna" 3 "Mumbai") pos(12) c(3) region(lc(none)) symxsize(medium)) ///
    xlab(${pct}) xoverhang xtit("") ///
    ylab(${pct}) ytit("TB Testing") yscale(noline) ylab(none, axis(2))

    graph save "${dir}/output/temp/qual-tb.gph" , replace


  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess test_cov  pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess test_cov  pre_correct  if city == 2 , lc(blue)  lw(thick)) ///
  , ${hist_opts} by(case, legend(off) imargin(medium) note("")) xsize(10) ///
    legend(off pos(12) c(3) region(lc(none)) symxsize(medium)) ///
    xlab(${pct}) xoverhang xtit("") ///
    ylab(${pct25}) ytit("Covid Testing") yscale(noline) ylab(none, axis(2))

    graph save "${dir}/output/temp/qual-co.gph" , replace

    graph combine ///
      "${dir}/output/temp/qual-tb.gph" ///
      "${dir}/output/temp/qual-co.gph" ///
      , c(1)
    graph draw, ysize(5)

  graph export "${dir}/output/quality.pdf" , replace

// Figure 2

  use "${dir}/data/constructed/sp-covet.dta" , clear

    egen tag = tag(uid)

    tw ///
      (histogram pre_checklist if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
      (lowess correct   pre_checklist  if city == 1 , lc(black) lw(thick)) ///
      (lowess test_cov  pre_checklist  if city == 1 , lc(black) lw(thick) lp(dash)) ///
      (lowess correct   pre_checklist  if city == 2 , lc(blue)  lw(thick)) ///
      (lowess test_cov  pre_checklist  if city == 2 , lc(blue)  lw(thick) lp(dash)) ///
    , ${hist_opts} ///
      legend(on pos(12) c(3) region(lc(none)) symxsize(medium) ///
             order(0 "Patna:" 2 "TB Test or Refer" 3 "Covid Test or Refer" 0 "Mumbai:" 4 "TB Test or Refer" 5 "Covid Test or Refer")) ///
      xlab(${pct75}) xoverhang xtit("TB Checklist Completion 2014-2019") ///
      ylab(${pct}) ytit("Current Quality") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

    graph export "${dir}/output/checklist.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(uid)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess cov_screen   pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess cov_screen   pre_correct  if city == 2 , lc(blue)  lw(thick)) ///
  , ${hist_opts} ytit(" ") ///
    legend(on pos(12) c(3) region(lc(none)) symxsize(med) ///
           order(2 "Patna" 3 "Mumbai")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct20}) title("Screening") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

    graph save "${dir}/output/temp/qual-screen.gph" , replace


  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess ppe   pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess ppe   pre_correct  if city == 2 , lc(blue)  lw(thick)) ///
  , ${hist_opts} ytit(" ") ///
    legend(on pos(12) c(3) region(lc(none)) symxsize(med) ///
           order(2 "Patna" 3 "Mumbai")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct}) title("Safety") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

  graph save "${dir}/output/temp/qual-ppe.gph" , replace

  grc1leg ///
    "${dir}/output/temp/qual-screen.gph" ///
    "${dir}/output/temp/qual-ppe.gph"

  graph export "${dir}/output/screening-safety.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(uid)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess ppe_1   pre_correct  ,  lw(thick) lc(navy)  lp(dash) ) ///
    (lowess ppe_3   pre_correct  ,  lw(thick) lc(black) lp(solid)) ///
    (lowess mask_hi pre_correct  ,  lw(thick) lc(black) lp(dash) ) ///
  , ${hist_opts} ///
    legend(on pos(12) c(3) region(lc(none))  colfirst ///
           order(2 "Patients Mask" 3 "Provider Masks"  4 "Surgical or N95")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct75}) ytit(" ") yscale(noline) ylab(none, axis(2))

    graph export "${dir}/output/masks.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(uid)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess ppe_2   pre_correct  ,  lw(thick) ) ///
    (lowess ppe_7   pre_correct  ,  lw(thick) ) ///
    (lowess cov_1 pre_correct  ,  lw(thick) ) ///
    (lowess cov_2 pre_correct  ,  lw(thick) ) ///
  , ${hist_opts} ///
    legend(on pos(12) c(3) region(lc(none))  colfirst ///
           order(2 "Distancing" 3 "Handwash"  4 "Screen Fever" 5  "Ask Covid History")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct20}) ytit(" ") yscale(noline) ylab(none, axis(2))

    graph export "${dir}/output/ppe.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var pre_correct "0%-100% increase in prior quality"

  forest reg ///
    (ppe_*) (cov_*) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) ///
    graph(ysize(5) scale(0.7) xlab(0 "Zero" .1 "+10p.p." .2 "+20p.p." .3 "+30p.p."))

    graph export "${dir}/output/impacts.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var pre_correct "0%-100% increase in prior quality"

  forest reg ///
    (correct test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9) ///
  , t(pre_correct) c(i.city i.case) b bh sort(local) ///
    graph(ysize(5) scale(0.7) xlab(0 "Zero" .1 "+10p.p." .2 "+20p.p." .3 "+30p.p."))


// End
