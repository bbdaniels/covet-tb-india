// Get data files set up for analysis

// Create blended data
use "${dir}/data/constructed/sp-combined.dta" ///
  if case == 1 | case == 9 , clear

  iecodebook export ///
  using "${dir}/data/constructed/sp-all.xlsx" ///
    , save sign reset replace

// Create pre-covet index
use "${dir}/data/constructed/sp-combined.dta" ///
  if round < 4 & case < 5 , clear

  egen checklist = rowmean(sp?_h_*)
    lab var checklist "Checklist"

  labelcollapse ///
    (mean) correct checklist ///
    , by (city fidcode)

    ren (correct checklist)(pre_correct pre_checklist)

  tempfile pre
    save `pre'

// Get COVET data
use "${dir}/data/constructed/sp-combined.dta" ///
  if round == 4, clear

  egen checklist = rowmean(sp?_h_*)
    lab var checklist "Checklist"

  merge m:1 city fidcode using `pre' , keep(1 3) nogen
    egen uid = group(city fidcode)
    lab var uid "Unique Facility ID"
    drop fidcode

  egen cov_screen = rowmax(cov_*)
    lab var cov_screen "Covid Screening"

  lab var med_anti_any_3 "Antibiotics"
  lab var correct "Correct"

  ren ppe_9 mask
    gen mask_hi = mask > 2
    lab var mask_hi "Surgical/N95"
  egen ppe = rowmax(ppe_*)
    lab var ppe "Covid Safety"

  egen test_cov = rowmax(test_cov*)
    lab var test_cov "Covid Test"
    lab val test_cov yesno

  iecodebook export ///
  using "${dir}/data/constructed/sp-covet.xlsx" ///
    , save sign reset replace


// End
