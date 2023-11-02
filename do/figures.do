

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

// Price-quality

use "${dir}/data/constructed/sp-all.dta" , clear
  tw ///
  (lowess correct price if case == 1) ///
  (lowess correct price if case == 2) ///
  (lowess correct price if case == 3) ///
  (lowess correct price if case == 4) ///
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

// End
