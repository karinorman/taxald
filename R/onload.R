.taxald_db <- NULL

#' @importFrom rappdirs user_data_dir
taxald_path <- function() {
  sys_fao_path <- Sys.getenv("TAXALD_HOME")
  if (sys_fao_path == "") {
    rappdirs::user_data_dir("taxald")
  }
}

#' The local FAOSTAT database
#'
#' Returns a connection to the local FAOSTAT MonetDB
#' @export
taxald_db <- function() {
  if(bindingIsLocked(".taxald_db", env=asNamespace("taxald"))) {
    unlockBinding(".taxald_db", env=asNamespace("taxald"))
  }
  if(is.null(.taxald_db)) {
    .taxald_db <<- td_connect()
  }
  .taxald_db
}

#' @export
td_disconnect <- function() {
  DBI::dbDisconnect(taxald_db())
  if(!is.null(.taxald_db)) .taxald_db <- NULL
}



.onAttach <- function(libname, pkgname) {
  if(interactive()) {
    td_connect()
  }
}
.onDetach <- function(libpath) {
  try(td_disconnect(), silent=TRUE)
}

.onUnload <- function(libpath) {
  try(td_disconnect(), silent=TRUE)
}