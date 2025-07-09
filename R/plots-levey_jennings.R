#' @title Plot Levey-Jennings chart
#'
#' @description
#' The function plots a Levey-Jennings chart for the given analyte
#' in the list of plates. The Levey-Jennings chart is a graphical
#' representation of the data that enables the detection of outliers
#' and trends. It is a quality control tool that is widely used
#' in the laboratories across the world.
#'
#' The method takes several parameters that can customise its output.
#' Except for the required parameters (`list_of_plates` and `analyte_name`),
#' the most significant optional ones are `dilution` and `sd_lines`.
#'
#' The additional parameters can be used for improving the plots interpretability, by customizing the layout, y-scale, etc.
#'
#' For better readibilty, the plot is zoomed out in the `y`-axis, by a factor of `1.5`.
#'
#' @param list_of_plates A list of plate objects for which to plot the
#' Levey-Jennings chart
#' @param analyte_name (`character(1)`) the analyte for which to plot the
#' Levey-Jennings chart
#' @param dilution (`character(1)`) the dilution for which to plot the
#' Levey-Jennings chart. The default is "1/400"
#' @param sd_lines (`numeric`) the vector of coefficients for the
#' standard deviation lines to plot, for example, c(1.96, 2.58)
#' will plot four horizontal lines: mean +/- 1.96*sd, mean +/- 2.58*sd
#' default is c(1, 2, 3) which will plot 6 lines in total
#' @param mfi_log_scale (`logical(1)`) specifies if the MFI should be in the `log10` scale.
#' By default it equals to `TRUE`, which corresponds to plotting the chart in `log10` scale.
#' @param sort_plates (`logical(1)`) if `TRUE` sorts plates by the date of examination.
#' If `FALSE` plots using the plate order as in input. `TRUE` by default.
#' @param plate_labels (`character(1)`) controls x-axis labels. Can improve readibility of the plot. Takes the following values:
#' * `"numbers"`: shows the number of the plate,
#' * `"names"`: shows the plate names
#' * `"dates"`: shows the date of examination
#' @param label_angle (`numeric(1)`) angle in degrees to rotate x-axis labels. Can improve readibility of the plot. Default: 0
#' @param data_type (`character(1)`) the type of data used plot. The default is "Median"
#' @param legend_position the position of the legend, a possible values are \code{c(`r toString(SerolyzeR.env$legend_positions)`)}. Is not used if `plot_legend` equals to `FALSE`.
#'
#' @importFrom stats setNames
#'
#' @return A ggplot object with the Levey-Jennings chart
#'
#' @examples
#' # creating temporary directory for the example
#' output_dir <- tempdir(check = TRUE)
#'
#' dir_with_luminex_files <- system.file("extdata", "multiplate_reallife_reduced",
#'   package = "SerolyzeR", mustWork = TRUE
#' )
#' list_of_plates <- process_dir(dir_with_luminex_files,
#'   return_plates = TRUE, format = "xPONENT", output_dir = output_dir
#' )
#' list_of_plates <- rep(list_of_plates, 10) # since we have only 3 plates i will repeat them 10 times
#'
#' plot_levey_jennings(list_of_plates, "ME", dilution = "1/400", sd_lines = c(0.5, 1, 1.96, 2.58))
#'
#' @export
plot_levey_jennings <- function(list_of_plates,
                                analyte_name,
                                dilution = "1/400",
                                sd_lines = c(1, 2, 3),
                                mfi_log_scale = TRUE,
                                sort_plates = TRUE,
                                plate_labels = "number",
                                label_angle = 0,
                                legend_position = "bottom",
                                data_type = "Median") {
  if (!is.list(list_of_plates)) {
    stop("The list_of_plates is not a list.")
  }
  if (length(list_of_plates) == 0) {
    stop("The list_of_plates is empty.")
  }
  if (length(list_of_plates) <= 10) {
    warning("The number of plates is less than 10. For the Levey-Jennings chart it is recommended to have at least 10 plates.")
  }
  if (!all(sapply(list_of_plates, inherits, "Plate"))) {
    stop("The list_of_plates contains objects that are not of class Plate.")
  }
  if (!is.character(analyte_name)) {
    stop("The analyte_name is not a string.")
  }
  if (!all(sapply(list_of_plates, function(plate) analyte_name %in% plate$analyte_names))) {
    plate_where_analyte_is_missing <- which(sapply(list_of_plates, function(plate) !(analyte_name %in% plate$analyte_names)))
    stop("The analyte_name is not present in plates ", paste(plate_where_analyte_is_missing, collapse = ", "))
  }
  if (!is.character(dilution)) {
    stop("The dilution is not a string.")
  }
  if (!all(sapply(list_of_plates, function(plate) dilution %in% plate$get_dilution("STANDARD CURVE")))) {
    plate_where_dilution_is_missing <- which(sapply(list_of_plates, function(plate) !(dilution %in% plate$get_dilution("STANDARD CURVE"))))
    stop("The dilution is not present in plates ", paste(plate_where_dilution_is_missing, collapse = ", "))
  }
  if (!is.numeric(sd_lines)) {
    stop("The sd_lines is not a numeric vector.")
  }
  if (length(sd_lines) > 6) {
    stop("It is impossible to have more than 6 pairs of standard deviation lines.")
  }
  if (!legend_position %in% SerolyzeR.env$legend_positions) {
    stop("legend_position must be one of: ", SerolyzeR.env$legend_positions)
  }
  if (!is.logical(mfi_log_scale) && length(mfi_log_scale) != 1) {
    stop("mfi_log_scale parameter should be a single boolean value")
  }

  if (!is.logical(sort_plates) && length(sort_plates) != 1) stop("sort_plates parameter should be a single boolean value")

  if (!is.numeric(label_angle) || length(label_angle) != 1) stop("label_angle must be numeric(1).")

  if (!(plate_labels %in% c("name", "number", "date"))) stop("plate_labels should be one of the following: 'name', 'number', or 'date'")


  # gather the data for the plot
  date_of_experiment <- c()
  mfi_values <- c()
  plate_names <- c()
  for (plate in list_of_plates) {
    dilutions <- plate$get_dilution("STANDARD CURVE")
    plate_data <- plate$get_data(analyte_name, "STANDARD CURVE", data_type)

    date_of_experiment <- c(date_of_experiment, plate$plate_datetime)
    mfi_values <- c(mfi_values, plate_data[dilutions == dilution])
    plate_names <- c(plate_names, plate$plate_name)
  }

  # convert the mfi into a depicted scale
  y_trans <- ifelse(mfi_log_scale, "log10", "identity")
  ylab <- format_ylab(data_type, y_trans)

  # calculate the aggregates
  mean <- mean(mfi_values)
  sd <- sd(mfi_values)

  # set up a dataframe of data to be plotted
  plot_data <- data.frame(
    date = as.POSIXct(date_of_experiment),
    mfi = mfi_values, plate = plate_names
  )

  if (sort_plates) {
    plot_data <- plot_data[order(plot_data$date), ]
  }

  # add pretty angles - if there is no angle provided the label should appear in the center
  hjust <- ifelse(label_angle == 0, 0.5, 1)

  # configure the labels
  plot_data$counter <- seq(1, length(mfi_values))

  if (plate_labels == "number") {
    xlab <- "Plate number"
    plot_data$label <- plot_data$counter
  } else if (plate_labels == "name") {
    xlab <- "Plate name"
    plot_data$label <- make.unique(as.character(plot_data$plate))
  } else {
    xlab <- "Examination date"
    plot_data$label <- make.unique(as.character(plot_data$date))
  }

  # add correct ordering for the plot
  plot_data$label <- factor(plot_data$label, levels = plot_data$label)

  # calculate plot y limits
  max_sd_line <- if (length(sd_lines) > 0) max(abs(sd_lines)) * sd else 0
  max_observed_deviation <- max(abs(plot_data$mfi - mean), na.rm = TRUE)
  max_range <- max(max_sd_line, max_observed_deviation)

  limit_factor <- 1.5
  y_limits <- c(mean - limit_factor * max_range, mean + limit_factor * max_range)

  p <- ggplot2::ggplot(data = plot_data, aes(x = .data$label, y = .data$mfi, group = 1)) +
    ggplot2::geom_point(size = 3, colour = "blue") +
    ggplot2::geom_line(linewidth = 1.1, colour = "blue") +
    ggplot2::geom_hline(yintercept = mean, color = "black", linewidth = 1) +
    ggplot2::labs(
      title = paste("Levey-Jennings chart for", analyte_name, "at", dilution, "dilution"),
      x = xlab,
      y = ylab
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.line = element_line(colour = "black"),
      axis.text.x = element_text(size = 9, angle = label_angle, vjust = 1, hjust = hjust),
      axis.text.y = element_text(size = 9),
      legend.position = legend_position,
      legend.background = element_rect(fill = "white", color = "black"),
      legend.title = element_blank(),
      panel.grid.minor = element_line(color = scales::alpha("grey", .5), linewidth = 0.1) # Make the minor grid lines less visible
    ) +
    ggplot2::scale_y_continuous(trans = y_trans) +
    ggplot2::coord_cartesian(ylim = y_limits)

  line_types <- c("dashed", "dotted", "dotdash", "longdash", "twodash", "1F")
  line_labels <- c()
  line_level <- c()
  counter <- 1
  # Add standard deviation lines
  for (sd_line in sd_lines) {
    line_labels <- c(line_labels, paste0("Mean +/- ", sd_line, " SD"))
    line_level <- c(line_level, mean + sd_line * sd)
    p <- p + ggplot2::geom_hline(yintercept = mean - sd_line * sd, linetype = line_types[counter])
    counter <- counter + 1
  }

  sd_lines_df <- data.frame(yintercept = line_level, label = line_labels)
  p <- p + ggplot2::geom_hline(
    data = sd_lines_df,
    aes(yintercept = .data$yintercept, linetype = .data$label),
    color = "black"
  )
  p <- p + ggplot2::scale_linetype_manual(
    values = setNames(line_types[seq_along(line_labels)], line_labels)
  )

  return(p)
}
