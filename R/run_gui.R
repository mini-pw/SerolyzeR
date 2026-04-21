# nocov start
#' Launch the interactive GUI Shiny app
#'
#' @export
run_gui <- function() {
  required_pkgs <- c("shiny", "shinyFiles", "fs", "DT")
  missing_pkgs <- required_pkgs[!vapply(
    required_pkgs, requireNamespace,
    quietly = TRUE, FUN.VALUE = logical(1)
  )]

  if (length(missing_pkgs) > 0) {
    stop(
      "To use the GUI, please install the following packages:\n",
      "install.packages(c('", paste(missing_pkgs, collapse = "', '"), "'))",
      call. = FALSE
    )
  }

  app_dir <- system.file("app", package = "SerolyzeR")
  if (app_dir == "") {
    stop(
      "Could not find the app directory. Try re-installing the package.",
      call. = FALSE
    )
  }

  # Ensure the app respects the caller's working directory for file dialogs
  options(SerolyzeR.launch_dir = getwd())
  shiny::runApp(app_dir, display.mode = "normal")
}
# nocov end
