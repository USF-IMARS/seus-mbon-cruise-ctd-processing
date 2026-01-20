ctd_plot_available_params <- function(ctd, vars) {
  ok <- vars[vars %in% names(ctd@data)]
  
  if (length(ok) == 0){
    cat("None of the requested variables exist")
    return(NULL)
  }
  
  message("Plotting: ", paste(ok, collapse = ", "))
  
  oce::plot(ctd, which = ok, main = "")
}