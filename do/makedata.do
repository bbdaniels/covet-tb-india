// Get data files set up for analysis

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

  merge m:1 city fidcode using `pre' , keep(1 3)

  iecodebook export ///
  using "${dir}/data/constructed/sp-covet.xlsx" ///
    , save sign reset replace


// End
