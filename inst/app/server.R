library(shiny)
library(DT)
library(shinyFiles)

# ---- Helpers ----
`%||%` <- function(x, y) if (is.null(x)) y else x

capture_all <- function(expr) {
  log_lines <- character(0)
  result <- tryCatch(
    withCallingHandlers(
      {
        out <- capture.output(expr, type = "output")
        if (length(out)) log_lines <<- c(log_lines, out)
        "success"
      },
      message = function(m) {
        log_lines <<- c(log_lines, conditionMessage(m))
        invokeRestart("muffleMessage")
      }
    ),
    error = function(e) e
  )
  list(result = result, log = paste(log_lines, collapse = "\n"))
}

status_box <- function(msg, is_error = FALSE) {
  bg <- if (is_error) "#f8d7da" else "#d4edda"
  border <- if (is_error) "#f5c6cb" else "#c3e6cb"
  color <- if (is_error) "#721c24" else "#155724"
  tags$div(
    style = paste0(
      "background-color:", bg, "; border:1px solid ", border, ";",
      "color:", color, "; padding:10px; border-radius:4px; margin-bottom:10px;"
    ),
    tags$strong(if (is_error) "Error" else "Done"),
    tags$span(paste0(" \u2014 ", msg))
  )
}

is_dir_writable <- function(dir) {
  if (is.null(dir)) return(FALSE)
  if (!is.character(dir) || length(dir) > 1) return(FALSE)
  dir.exists(dir) && file.access(dir, mode = 2) == 0
}

is_dir_readable <- function(dir) {
  if (is.null(dir)) return(FALSE)
  if (!is.character(dir) || length(dir) > 1) return(FALSE)
  dir.exists(dir) && file.access(dir, mode = 4) == 0
}

launch_dir <- getOption("SerolyzeR.launch_dir", getwd())
launch_dir <- path.expand(launch_dir)
roots <- c(
  home = path.expand("~"),
  cwd = launch_dir
)
path_relative_to_home <- function(path) {
  home <- path.expand("~")
  if (startsWith(path, home)) {
    return(paste0(substring(path, nchar(home) + 1)))
  }
  path
}

get_status_tick_ui <- function(status) {
  if (status == "success") {
    icon("check-circle", class = "icon-tick text-success")
  } else if (status == "error") {
    icon("times-circle", class = "icon-cross text-danger")
  } else if (status == "processing") {
    icon("spinner", class = "fa-spin icon-loading")
  } else {
    icon("question-circle", class = "icon-pending text-muted")
  }
}

# ---- Server ----
server <- function(input, output, session) {
  # Helpers
  shinyFileChooseWrapped <- function(id, filepath_rv, callback) {
    shinyFileChoose(input, id,
      defaultPath = path_relative_to_home(last_dir()),
      defaultRoot = "home", roots = roots, session = session
    )
    observeEvent(input[[id]], {
      fileinfo <- parseFilePaths(roots = roots, input[[id]])
      req(nrow(fileinfo) > 0)
      filepath <- fileinfo$datapath
      filepath_rv(filepath)
      last_dir(path.expand(dirname(filepath)))
      callback(filepath)
    })
  }
  shinyDirChooseWrapped <- function(id, dirpath_rv, callback) {
    shinyDirChoose(input, id,
      defaultPath = ".", defaultRoot = "cwd",
      roots = roots, session = session
    )
    observeEvent(input[[id]], {
      dirinfo <- parseDirPath(roots = roots, input[[id]])
      req(length(dirinfo) > 0 && dir.exists(dirinfo))
      dirpath_rv(path.expand(dirinfo))
      callback(path.expand(dirinfo))
    })
  }


  # Reactive values for inputs
  last_dir <- reactiveVal(launch_dir)
  sp_plate_path_rv <- reactiveVal(NULL)
  sp_layout_file_rv <- reactiveVal(NULL)
  sp_output_dir_rv <- reactiveVal(NULL)
  
  # Reactive values for intermediate/output data
  sp_plate_format_rv <- reactiveVal(NULL)
  sp_plate_rv <- reactiveVal(NULL)
  sp_status_val <- reactiveVal("Awaiting inputs...")
  sp_log_val <- reactiveVal("")
  sp_out_dir_val <- reactiveVal(NULL)

  # Status trackers for the UI icons ("pending", "processing", "success", "error")
  sp_plate_status <- reactiveVal("pending")
  sp_layout_status <- reactiveVal("pending")
  sp_output_status <- reactiveVal("pending")
  sp_layout_shape_rv <- reactiveVal(NULL)
  sp_layout_n_wells_rv <- reactiveVal(NULL)

  ## Input buttons
  ### Plate input
  shinyFileChooseWrapped("sp_plate_btn", sp_plate_path_rv, function(filepath) {
    sp_plate_status("processing")
    tryCatch({
      format <- detect_mba_format(filepath)
      sp_plate_format_rv(format)
      sp_plate_status("success")
      sp_log_val(paste0("Plate format detected: ", format))
    }, error = function(e) {
      sp_plate_format_rv(NULL)
      sp_plate_status("error")
      sp_log_val(paste0("Error detecting plate format: ", conditionMessage(e)))
    })
  })
  shinyFileChooseWrapped("sp_layout_btn", sp_layout_file_rv, function(filepath) {
    sp_layout_status("processing")
    # Reset the text values when a new file is chosen
    sp_layout_shape_rv(NULL)
    sp_layout_n_wells_rv(NULL)

    captured <- capture_all({
      layout_data <- read_layout_data(filepath)
      sp_layout_shape_rv(paste0(nrow(layout_data), " x ", ncol(layout_data)))
      sp_layout_n_wells_rv(sum(!is.na(layout_data)))
    })
    if (inherits(captured$result, "error")) {
      sp_layout_status("error")
      sp_log_val(paste("Could not read the layout. ", captured$log, "\n", conditionMessage(captured$result)))
    } else {
      sp_layout_status("success")
      sp_log_val(paste0("Layout read correctly.\n", captured$log))
    }
  })
  shinyDirChooseWrapped("sp_output_btn", sp_output_dir_rv, function(selected_dir) {
    sp_output_status("processing")
    if (is_dir_writable(selected_dir)) {
      sp_output_status("success")
      sp_log_val(paste0("Output directory is ready to write."))
    } else {
      sp_output_status("error")
      sp_log_val(paste0("Output directory does not exists or writes are not allowed."))
    }
  })

  # UI outputs for status icons and paths
  output$sp_plate_check <- renderUI(get_status_tick_ui(sp_plate_status()))
  output$sp_layout_check <- renderUI(get_status_tick_ui(sp_layout_status()))
  output$sp_output_dir_check <- renderUI(get_status_tick_ui(sp_output_status()))

  output$sp_plate_path <- renderText(sp_plate_path_rv() %||% "No file selected")
  output$plate_detected_format <- renderText(sp_plate_format_rv() %||% "")
  output$sp_layout_path <- renderText(sp_layout_file_rv() %||% "No file selected")
  output$sp_layout_shape <- renderText({ sp_layout_shape_rv() %||% "" })
  output$sp_layout_n_wells <- renderText({ sp_layout_n_wells_rv() %||% "" })
  output$sp_output_dir_rv <- renderText(sp_output_dir_rv() %||% "No directory selected")

  output$sp_log <- renderPrint(cat(sp_log_val()))


  # RUN BUTTON
  observeEvent(input$sp_run, {
    ## Prechecks
    if (sp_plate_status() != "success" || sp_layout_status() != "success" || sp_output_status() != "success") {
      sp_status_val(status_box(
        "Please ensure all inputs are valid before running.", is_error = TRUE
      ))
      return()
    }
    if (length(input$sp_norm_types) == 0) {
      sp_status_val(status_box(
        "Please select at least one normalisation type", is_error = TRUE
      ))
      return()
    }

    plate_path <- sp_plate_path_rv()
    layout_path <- sp_layout_file_rv()
    out_dir <- path.expand(sp_output_dir_rv())

    sp_status_val(NULL)
    sp_log_val("")
    sp_out_dir_val(NULL)

    format <- ifelse(
      input$sp_format == "AUTO", sp_plate_format_rv(), input$sp_format
    )

    withProgress(message = "Processing plate, please wait\u2026", value = 0.5, {
      captured <- capture_all({
        plate <- SerolyzeR::process_file(
          plate_filepath      = plate_path,
          layout_filepath     = layout_path,
          output_dir          = out_dir,
          format              = format,
          normalisation_types = input$sp_norm_types,
          generate_report     = input$sp_report,
          blank_adjustment    = input$sp_blank_adj,
          verbose             = TRUE
        )
        sp_plate_rv(plate)
      })
    })

    sp_log_val(captured$log)

    if (inherits(captured$result, "error")) {
      sp_status_val(status_box(
        conditionMessage(captured$result), is_error = TRUE
      ))
    } else {
      abs_out <- normalizePath(out_dir, mustWork = FALSE)
      sp_out_dir_val(abs_out)
      sp_status_val(status_box(
        paste0("Plate processed. Output written to: ", abs_out)
      ))
    }
  })

  output$sp_status <- renderUI({
    tagList(
      sp_status_val(),
      if (!is.null(sp_out_dir_val())) {
        actionButton("sp_show_plate_counts", "Show plate layout",
          icon = icon("table-cells"), class = "btn-default",
          style = "margin-top:6px;"
        )
      },
      if (!is.null(sp_out_dir_val())) {
        actionButton("sp_open_dir", "Open output directory",
          icon = icon("folder-open"), class = "btn-default",
          style = "margin-top:6px;"
        )
      }
    )
  })

  observeEvent(input$sp_show_plate_counts, {
    req(sp_plate_rv())
    showModal(modalDialog(
      title = "Plate layout",
      renderPlot(SerolyzeR:::plot_layout(sp_plate_rv())),
      easyClose = TRUE,
      size = "l"
    ))
  })

  observeEvent(input$sp_open_dir, {
    browseURL(paste0("file://", sp_out_dir_val()))
  })


  # ==================================================
  # ==================================================


  # ===== Process Directory =====
  pd_input_dir_rv <- reactiveVal(NULL)
  pd_output_dir_rv <- reactiveVal(NULL)
  pd_layout_file_rv <- reactiveVal(NULL)

  pd_status_val <- reactiveVal(NULL)
  pd_log_val <- reactiveVal("")

  pd_input_status <- reactiveVal("pending")
  pd_input_list <- reactiveVal(NULL)
  pd_output_status <- reactiveVal("pending")
  pd_layout_status <- reactiveVal("pending")
  pd_layout_shape_rv <- reactiveVal(NULL)
  pd_layout_n_wells_rv <- reactiveVal(NULL)
  pd_out_dir_val <- reactiveVal(NULL)

  shinyDirChooseWrapped("pd_input_btn", pd_input_dir_rv, function(selected_dir) {
    if (!is_dir_readable(selected_dir)) {
      pd_input_status("error")
      pd_log_val(paste0("Input directory does not exists or writes are not allowed."))
      return()
    }
    mba_format <- if (input$pd_format == "AUTO") NULL else input$pd_format
    captured <- capture_all({
      input_list <- SerolyzeR::process_dir(
        input_dir                   = selected_dir,
        recurse                     = input$pd_recurse,
        dry_run                     = TRUE,
        format                      = mba_format,
        verbose                     = FALSE
      )
      input_list$is_ready <- (!is.na(input_list$formats)) & (!is.na(input_list$layouts))
      pd_input_list(input_list)
    })
    if (inherits(captured$result, "error")) {
      pd_input_status("error")
      pd_log_val(paste0(
        "Failed to read input directory contents. ", captured$log
      ))
      return()
    }
    pd_input_status("success")
    pd_log_val(paste0(
      "Input directory contains ", length(pd_input_list()$files), " MBA files."
    ))
  })

  shinyDirChooseWrapped("pd_output_btn", pd_output_dir_rv, function(selected_dir) {
    if (is_dir_writable(selected_dir)) {
      pd_output_status("success")
      pd_log_val(paste0("Output directory is ready to write."))
    } else {
      pd_output_status("error")
      pd_log_val(paste0("Output directory does not exists or writes are not allowed."))
    }
  })

  shinyFileChooseWrapped("pd_layout_btn", pd_layout_file_rv, function(filepath) {
    pd_layout_status("processing")

    pd_layout_shape_rv(NULL)
    pd_layout_n_wells_rv(NULL)

    captured <- capture_all({
      layout_data <- read_layout_data(filepath)
      pd_layout_shape_rv(paste0(nrow(layout_data), " x ", ncol(layout_data)))
      pd_layout_n_wells_rv(sum(!is.na(layout_data)))
    })
    if (inherits(captured$result, "error")) {
      pd_layout_status("error")
      pd_log_val(paste("Could not read the layout. ", captured$log, "\n", conditionMessage(captured$result)))
    } else {
      pd_log_val(paste0("Layout read correctly.\n", captured$log))
      pd_layout_status("success")
    }
  })
  observeEvent(input$pd_layout_clear_btn, {
    pd_layout_file_rv(NULL)
    pd_layout_status("pending")
    pd_layout_shape_rv(NULL)
    pd_layout_n_wells_rv(NULL)
    pd_log_val("Layout file cleared.")
  })

  output$pd_input_path <- renderText(pd_input_dir_rv() %||% "No directory selected")
  output$pd_output_path <- renderText(pd_output_dir_rv() %||% "No directory selected")
  output$pd_layout_path <- renderText(pd_layout_file_rv() %||% "None (auto-detected per plate)")

  output$pd_input_check <- renderUI(get_status_tick_ui(pd_input_status()))
  output$pd_output_check <- renderUI(get_status_tick_ui(pd_output_status()))
  output$pd_layout_check <- renderUI(get_status_tick_ui(pd_layout_status()))

  output$pd_number_mba_files <- renderText({
    if (is.null(pd_input_list())) return("")
    pd_input_list()$files %>% length()
  })
  output$pd_number_missing_layout_files <- renderText({
    if (is.null(pd_input_list())) return("")
    pd_input_list()$layouts %>% is.na() %>% sum()
  })
  output$pd_number_non_detected_formats <- renderText({
    if (is.null(pd_input_list())) return("")
    pd_input_list()$formats %>% is.na() %>% sum()
  })
  output$pd_layout_shape <- renderText(pd_layout_shape_rv() %||% "")
  output$pd_layout_n_wells <- renderText(pd_layout_n_wells_rv() %||% "")
  # Show files nicely
  observeEvent(input$show_files, {
    req(pd_input_list())
    input_list <- pd_input_list()
    req(length(input_list$files) > 0)
    df <- data.frame(
      Path = input_list$files,
      Layout = !is.na(input_list$layouts),
      Format = input_list$formats,
      IsReady = input_list$is_ready,
      stringsAsFactors = FALSE
    )
    # Flag and sort problematic rows
    df <- df[order(df$IsReady), ]
    df <- df[, c("Path", "Layout", "Format")]

    showModal(modalDialog(
      title = "File validation",
      size = "l",
      DTOutput("file_table"),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))

    output$file_table <- renderDT({
      datatable(
        df,
        rownames = FALSE,
        escape = FALSE,
        options = list(
          pageLength = 10,
          autoWidth = TRUE,
          columnDefs = list(
            list(
              targets = 0,
              render = JS(
                "function(data, type, row, meta) {",
                "return '<div style=\"white-space: normal; word-break: break-all;\">' + data + '</div>';",
                "}"
              )
            )
          )
        )
      ) %>%
        formatStyle(
          "Layout",
          backgroundColor = styleEqual(
            c(TRUE, FALSE),
            c("#c8e6c9", "#ffcdd2")
          )
        ) %>%
        formatStyle(
          "Format",
          backgroundColor = styleEqual(
            c(SerolyzeR.env$mba_formats, NA_character_),
            c(rep("#c8e6c9", length(SerolyzeR.env$mba_formats)), "#ffcdd2")
          )
        )
    })
  })

  observeEvent(input$pd_run, {
    req(pd_input_status() == "success")
    req(pd_input_list())
    req(pd_output_status() == "success")
    req(pd_layout_status() != "error")

    in_dir <- pd_input_dir_rv()
    out_dir <- pd_output_dir_rv()
    layout_file <- pd_layout_file_rv()
    mba_format <- input$pd_format
    if (mba_format == "AUTO") mba_format <- NULL

    pd_status_val(NULL)
    pd_log_val("")
    pd_out_dir_val(NULL)

    withProgress(message = "Processing directory, please wait\u2026", value = 0.5, {
      captured <- capture_all({
        SerolyzeR::process_dir(
          input_dir                   = in_dir,
          output_dir                  = out_dir,
          layout_filepath             = layout_file,
          format                      = mba_format,
          normalisation_types         = input$pd_norm_types,
          recurse                     = input$pd_recurse,
          flatten_output_dir          = input$pd_flatten,
          generate_reports            = input$pd_reports,
          generate_multiplate_reports = input$pd_multiplate,
          column_collision_strategy   = input$pd_col_collision,
          merge_outputs               = input$pd_merge,
          verbose                     = TRUE
        )
      })
    })

    pd_log_val(captured$log)
    if (inherits(captured$result, "error")) {
      pd_status_val(status_box(conditionMessage(captured$result), is_error = TRUE))
    } else {
      dest <- normalizePath(if (is.null(out_dir)) in_dir else out_dir, mustWork = FALSE)
      pd_out_dir_val(dest)
      pd_status_val(status_box(paste0("Directory processed. Output written to: ", dest)))
    }
  })

  output$pd_status <- renderUI({
    tagList(
      pd_status_val(),
      if (!is.null(pd_out_dir_val())) {
        actionButton("pd_open_dir", "Open output directory",
          icon = icon("folder-open"), class = "btn-default",
          style = "margin-top:6px;"
        )
      }
    )
  })
  output$pd_log <- renderPrint(cat(pd_log_val()))

  observeEvent(input$pd_open_dir, {
    browseURL(paste0("file://", pd_out_dir_val()))
  })
}
