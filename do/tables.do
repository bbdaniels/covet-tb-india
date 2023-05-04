// Tables for COVET Paper

// Table 1. Summary statistics
use "${dir}/data/constructed/sp-covet.dta" , clear

  lab var correct "TB Test or Refer"
  lab var pre_correct "Prior Quality"

  ren cov_screen screen
    lab var screen "Any Screening"
    lab var ppe "Any Safety"

  iebaltab ///
    (correct pre_correct checklist pre_checklist ///
     test_cov test_cxr test_afb test_gx refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9 ///
     ppe ppe_3 mask_hi ppe_1 ///
     screen cov_1 cov_2 cov_3 cov_4 cov_5 cov_6) ///
  , group(city) replace savexlsx("${dir}/output/summary-city.xlsx") ///
    nonote rowvarlabels total stats(pair(beta)) control(1) cov(i.case) vce(cluster uid)

// Table 2. Summary statistics

iebaltab ///
  (correct pre_correct checklist pre_checklist ///
   test_cov test_cxr test_afb test_gx refer ///
   med_anti_any_3 med_anti_any_2 med_code_any_9 ///
   ppe ppe_3 mask_hi ppe_1 ///
   screen cov_1 cov_2 cov_3 cov_4 cov_5 cov_6) ///
  , group(case) replace savexlsx("${dir}/output/summary-case.xlsx") ///
    nonote rowvarlabels total stats(desc(sd) pair(beta)) control(1) cov(i.city) vce(cluster uid)

// Table 3. Regression estimates
use "${dir}/data/constructed/sp-covet.dta" , clear

local varlist correct test_cxr test_afb test_gx test_cov refer ///
              med_anti_any_3 med_anti_any_2 med_code_any_9

foreach var of varlist  `varlist'  {
  reg `var' ///
    i.city 9.case pre_* ppe_1 ppe_3 mask_hi , cl(uid) coefl

    est sto `var'
    local labels = `"`labels' "`:var lab `var''" "'
  }

outwrite `varlist' using "${dir}/output/regressions.xlsx" , replace col(`labels') stats(N r2)

// Table 4. Regression estimates
use "${dir}/data/constructed/sp-covet.dta" , clear

local varlist ppe_* mask_hi

foreach var of varlist  `varlist'  {
  reg `var' ///
    i.city 9.case pre_* correct test_cxr test_afb test_gx test_cov refer , cl(uid) coefl

    est sto `var'
    local labels = `"`labels' "`:var lab `var''" "'
  }

outwrite `varlist' using "${dir}/output/regressions2.xlsx" , replace col(`labels') stats(N r2)



// End
