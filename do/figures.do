

// Variation across

  use "${dir}/data/constructed/sp-all.dta" , clear

  mixed correct || case: || uid:
    estat icc

  reg correct i.case
  reg correct i.case, a(uid)


  mixed checklist || case: || uid:
    estat icc

  reg checklist i.case
  reg checklist i.case, a(uid)

// Price-quality binscatters
use "${dir}/data/constructed/sp-all.dta" if price < 2000 & price > 0 & time < 15, clear

  collapse (mean) price checklist correct refer time med, by(uid)

  graph matrix price checklist correct refer time med

  binsreg price checklist correct refer time med   ///
    , polyreg(3)
  binsreg price correct checklist  refer time med   ///
    , polyreg(3)
  binsreg price time checklist correct refer  med   ///
    , polyreg(3)
  binsreg price med correct checklist  refer time    ///
    , polyreg(3)

  binsreg price checklist  if price < 2000 & price > 0 , polyreg(3)

// Price-quality

use "${dir}/data/constructed/sp-all.dta" , clear
  tw ///
  (lowess correct price if case == 1) ///
  (lowess correct price if case == 2) ///
  (lowess correct price if case == 3) ///
  (lowess correct price if case == 4) ///
 if price < 2000 & price > 0 , by(city) ///
   legend(order(1 "Case 1" 2 "Case 2" 3 "Case 3" 4 "Case 4"))


use "${dir}/data/constructed/sp-all.dta" , clear
  tw ///
  (lowess checklist price if case == 1) ///
  (lowess checklist price if case == 2) ///
  (lowess checklist price if case == 3) ///
  (lowess checklist price if case == 4) ///
 if price < 2000 & price > 0 , by(city) ///
  legend(order(1 "Case 1" 2 "Case 2" 3 "Case 3" 4 "Case 4"))


use "${dir}/data/constructed/sp-all.dta" , clear
 tw ///
 (lowess correct checklist if case == 1) ///
 (lowess correct checklist if case == 2) ///
 (lowess correct checklist if case == 3) ///
 (lowess correct checklist if case == 4) ///
if price < 2000 & price > 0 , by(city) ///
 legend(order(1 "Case 1" 2 "Case 2" 3 "Case 3" 4 "Case 4"))

// Lag prediction

  // V1 -- no duplicates
  use "${dir}/data/constructed/sp-all.dta" , clear

    duplicates tag uid case round , gen(dup)
      drop if dup

    egen uuid = group(uid case)
    xtset uuid round

    xtreg correct L.correct

  // V2 -- provider-case-level
  use "${dir}/data/constructed/sp-all.dta" , clear

  collapse (mean) correct , by(uid case round)

    egen uuid = group(uid case)
    xtset uuid round

    xtreg correct L.correct

  // V3 -- provider-level
  use "${dir}/data/constructed/sp-all.dta" , clear

  collapse (mean) correct , by(uid round)

    xtset uid round

    xtreg correct L.correct

  // V3 -- Case 1
  use "${dir}/data/constructed/sp-all.dta" if case == 1, clear

  collapse (mean) correct case, by(uid round)

    xtset uid round

    xtreg correct L.correct

// Lag prediction -- ROC

use "${dir}/data/constructed/sp-all.dta" , clear
  keep if case == 1
  keep correct uid round
  collapse (mean) correct , by(uid round)
  reshape wide correct, i(uid) j(round)

  merge 1:m uid using "${dir}/data/constructed/sp-all.dta"
  keep if case == 1

  logit correct correct1 i.case if round > 1
  lroc

  logit correct correct1 correct2 i.case if round > 2
  lroc

  logit correct correct1 correct2 correct3 i.case if round > 3
  lroc

  use "${dir}/data/constructed/sp-all.dta" , clear
    keep correct uid round
    collapse (mean) correct , by(uid round)
    reshape wide correct, i(uid) j(round)

  merge 1:m uid using "${dir}/data/constructed/sp-all.dta"

  logit correct correct1 i.case if round > 1
  lroc

  logit correct correct1 correct2 i.case if round > 2
  lroc

// End
