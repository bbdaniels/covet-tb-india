use "${dir}/data/constructed/sp-all.dta" , clear

// Variation across

  mixed correct || case: || uid:
    estat icc

  reg correct i.case
  reg correct i.case, a(uid)

// Lag prediction



// End
