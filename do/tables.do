// Tables for COVET Paper

// Table 1. Summary statistics
use "${dir}/data/constructed/sp-covet.dta" , clear

  iebaltab ///
    (correct pre_correct checklist pre_checklist ///
     test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9 ///
     cov_screen ppe_3 mask_hi  ppe_1 ppe_7) ///
  , group(city) replace savexlsx("${dir}/output/summary-city.xlsx") ///
    nonote rowvarlabels total stats(desc(sd) pair(beta)) control(1)

// Table 2. Summary statistics
use "${dir}/data/constructed/sp-covet.dta" , clear

  iebaltab ///
    (correct pre_correct checklist pre_checklist ///
     test_cxr test_afb test_gx test_cov refer ///
     med_anti_any_3 med_anti_any_2 med_code_any_9 ///
     cov_screen ppe_3 mask_hi  ppe_1 ppe_7) ///
  , group(case) replace savexlsx("${dir}/output/summary-case.xlsx") ///
    nonote rowvarlabels total stats(desc(sd) pair(beta)) control(1)

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

// End
