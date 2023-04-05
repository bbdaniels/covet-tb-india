// Figures for SP Covet Paper

// Figure 1

  betterbarci ///
    correct test_cxr test_afb test_gx test_cov refer ///
    med_anti_any_3 med_anti_any_2 med_code_any_9 ///
  if city == 1 ///
    , over(case) legend(on) xlab(${pct}) xoverhang title("Patna") barc(red gray) bar pct ///
      legend(order(1 "Standard TB Case" 2 "Covid-Like Case"))

  graph save "${dir}/output/temp/bar-patna.gph" , replace

  betterbarci ///
    correct test_cxr test_afb test_gx test_cov refer ///
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

  egen tag = tag(city fidcode)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess correct   pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess test_cov  pre_correct  if city == 1 , lc(black) lw(thick) lp(dash)) ///
    (lowess correct   pre_correct  if city == 2 , lc(navy)  lw(thick)) ///
    (lowess test_cov  pre_correct  if city == 2 , lc(navy)  lw(thick) lp(dash)) ///
  , ${hist_opts} ///
    legend(on pos(12) c(3) region(lc(none)) symxsize(med) ///
           order(0 "Patna:" 2 "TB Test or Refer" 3 "Covid Test or Refer" 0 "Mumbai:" 4 "TB Test or Refer" 5 "Covid Test or Refer")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct}) ytit("Current Quality") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

  graph export "${dir}/output/quality.pdf" , replace

// Figure 2

  use "${dir}/data/constructed/sp-covet.dta" , clear

    egen tag = tag(city fidcode)

    tw ///
      (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
      (lowess correct   pre_checklist  if city == 1 , lc(black) lw(thick)) ///
      (lowess test_cov  pre_checklist  if city == 1 , lc(black) lw(thick) lp(dash)) ///
      (lowess correct   pre_checklist  if city == 2 , lc(navy)  lw(thick)) ///
      (lowess test_cov  pre_checklist  if city == 2 , lc(navy)  lw(thick) lp(dash)) ///
    , ${hist_opts} ///
      legend(on pos(12) c(3) region(lc(none)) symxsize(med) ///
             order(0 "Patna:" 2 "TB Test or Refer" 3 "Covid Test or Refer" 0 "Mumbai:" 4 "TB Test or Refer" 5 "Covid Test or Refer")) ///
      xlab(${pct}) xoverhang xtit("TB Checklist Completion 2014-2019") ///
      ylab(${pct}) ytit("Current Quality") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

    graph export "${dir}/output/checklist.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(city fidcode)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess cov_screen   pre_correct  if city == 1 , lc(black) lw(thick)) ///
    (lowess ppe          pre_correct  if city == 1 , lc(black) lw(thick) lp(dash)) ///
    (lowess cov_screen   pre_correct  if city == 2 , lc(navy)  lw(thick)) ///
    (lowess ppe          pre_correct  if city == 2 , lc(navy)  lw(thick) lp(dash)) ///
  , ${hist_opts} ///
    legend(on pos(12) c(3) region(lc(none)) symxsize(med) ///
           order(0 "Patna:" 2 "Any Covid Screening" 3 "Any Covid Safety" 0 "Mumbai:" 4 "Any Covid Screening" 5 "Any Covid Safety")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct}) ytit("Current Quality") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

  graph export "${dir}/output/screening-safety.pdf" , replace

// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  egen tag = tag(city fidcode)

  tw ///
    (histogram pre_correct if tag == 1, frac yaxis(2) color(gs14) start(0) w(0.05) gap(10)) ///
    (lowess cov_1   pre_correct  ,  lw(thick) lc(red)   lp(solid)) ///
    (lowess cov     pre_correct  ,  lw(thick) lc(red)   lp(dash) ) ///
    (lowess ppe_7   pre_correct  ,  lw(thick) lc(navy)  lp(solid)) ///
    (lowess ppe_1   pre_correct  ,  lw(thick) lc(navy)  lp(dash) ) ///
    (lowess ppe_3   pre_correct  ,  lw(thick) lc(black) lp(solid)) ///
    (lowess mask_hi pre_correct  ,  lw(thick) lc(black) lp(dash) ) ///
  , ${hist_opts} ///
    legend(on pos(12) c(3) region(lc(none)) symxsize(med) colfirst ///
           order(2 "Screen Fever" 3 "Covid Suspicion" 4 "Handwash" 5 "Patients Mask" 6 "Provider Mask"  7 "Surgical or N95")) ///
    xlab(${pct}) xoverhang xtit("TB Management Quality 2014-2019") ///
    ylab(${pct}) ytit("Share of Interactions") yscale(noline) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%", axis(2))

    graph export "${dir}/output/safety-indiv.pdf" , replace

// End
