library(shiny)
library(shinyFiles)

path_display <- function(output_id) {
  tags$div(
    style = paste(
      "word-break:break-all; overflow-wrap:anywhere;",
      "font-size:0.82em; color:#555; margin:3px 0 8px; min-height:1.2em;"
    ),
    textOutput(output_id)
  )
}

# ---- UI ----
single_plate_tab <- tabPanel(
  "Single Plate",
  sidebarLayout(
    sidebarPanel(
      style = "padding-top: 10px; padding-bottom: 10px;",
      tags$div(
        style = "display: flex; gap: 10px",
        h4("Plate file"),
        shinyFilesButton(
          "sp_plate_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select plate file", multiple = FALSE
        ),
      ),
      path_display("sp_plate_path"),
      tags$div(
        style = "display: flex; gap: 10px",
        h4("Layout file"),
        shinyFilesButton(
          "sp_layout_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select layout file", multiple = FALSE
        ),
      ),
      path_display("sp_layout_path"),
      tags$div(
        style = "display: flex; gap: 10px",
        h4("Output directory", style = "text-wrap: nowrap;"),
        shinyDirButton(
          "sp_output_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select output directory"
        ),
      ),
      path_display("sp_output_dir_rv"),
      hr(),
      selectInput("sp_format", "File format",
        choices  = c("AUTO", "xPONENT", "INTELLIFLEX", "BIOPLEX"),
        selected = "AUTO"
      ),
      checkboxGroupInput("sp_norm_types", "Normalisation types",
        choices  = c("MFI", "RAU", "nMFI"),
        selected = c("MFI", "RAU", "nMFI"),
        inline   = TRUE
      ),
      checkboxInput("sp_report", "Generate QC report", value = FALSE),
      checkboxInput("sp_blank_adj", "Blank adjustment", value = FALSE),
      br(),
      actionButton("sp_run", "Run", class = "btn-primary btn-lg", width = "100%")
    ),
    mainPanel(
      column(
        width = 12,
        # --- PLATE FILE STATUS
        h4("Status"),
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Plate file", class = "rect-title"),
            tags$div(
              class = "rect-values",
              tags$span("Auto-Detected format: "),
              textOutput("plate_detected_format", inline = TRUE)
            )
          ),
          uiOutput("sp_plate_check")
        ),
        # --- LAYOUT FILE STATUS
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Layout file", class = "rect-title"),
            tags$div(
              class = "rect-values",
              tags$span("Shape: ", ),
              textOutput("sp_layout_shape", inline = TRUE),
              tags$span("", style = "margin-right: 15px;"),
              tags$span("Num wells: "),
              textOutput("sp_layout_n_wells", inline = TRUE),
            )
          ),
          uiOutput("sp_layout_check")
        ),
        # --- OUTPUT STATUS
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Output directory", class = "rect-title"),
          ),
          uiOutput("sp_output_dir_check")
        ),
        tags$hr(),
        h4("Run status: "),
        tags$div(
          style = "padding-left: 3%;",
          uiOutput("sp_status")
        ),
        tags$hr(),
        h4("Run logs: "),
        tags$div(
          style = "padding-left: 3%;",
          textOutput("sp_log")
        )
      ),
    )
  )
)

process_dir_tab <- tabPanel(
  "Process Directory",
  sidebarLayout(
    sidebarPanel(
      style = "padding-top: 10px; padding-bottom: 10px;",

      tags$div(
        style = "display: flex; gap: 10px",
        h4("Input directory", style = "text-wrap: nowrap;"),
        shinyDirButton(
          "pd_input_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select input directory"
        ),
      ),
      path_display("pd_input_path"),

      tags$div(
        style = "display: flex; gap: 10px",
        h4("Output directory", style = "text-wrap: nowrap;"),
        shinyDirButton(
          "pd_output_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select output directory"
        ),
      ),
      path_display("pd_output_path"),

      tags$div(
        style = "display: flex; gap: 10px",
        h4("Layout file", style = "text-wrap: nowrap;"),
        shinyFilesButton(
          "pd_layout_btn", class = "btn-smaller",
          label = "Browse\u2026",
          title = "Select layout file", multiple = FALSE
        ),
        actionButton("pd_layout_clear_btn", "Unselect", class = "btn-smaller"),
      ),
      path_display("pd_layout_path"),

      hr(),
      selectInput("pd_format", "File format",
        choices  = c("AUTO", "xPONENT", "INTELLIFLEX", "BIOPLEX"),
        selected = "AUTO"
      ),
      checkboxGroupInput("pd_norm_types", "Normalisation types",
        choices  = c("MFI", "RAU", "nMFI"),
        selected = c("MFI", "RAU", "nMFI"),
        inline   = TRUE
      ),
      checkboxInput("pd_recurse", "Search subdirectories", value = FALSE),
      checkboxInput("pd_flatten", "Flatten output directory structure", value = FALSE),
      checkboxInput("pd_reports", "Per-plate QC reports", value = FALSE),
      checkboxInput("pd_multiplate", "Multiplate QC report", value = FALSE),
      checkboxInput("pd_merge", "Merge outputs into single CSV", value = TRUE),
      selectInput("pd_col_collision", "Column collision strategy",
        choices  = c("union", "intersection"),
        selected = "intersection"
      ),
      br(),
      actionButton("pd_run", "Run", class = "btn-primary btn-lg", width = "100%")
    ),
    mainPanel(
      column(
        width = 12,
        h4("Status"),
        # --- INPUT STATUS
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Input directory", class = "rect-title"),
            tags$div(
              class = "rect-values",
              tags$span("Number of MBA files: ", ),
              textOutput("pd_number_mba_files", inline = TRUE),
              tags$br(),
              tags$div(
                style = "margin-left: 10px;",
                tags$span("without Auto-Detected layout file: ", ),
                textOutput("pd_number_missing_layout_files", inline = TRUE),
                tags$br(),
                tags$span("without set format: ", ),
                textOutput("pd_number_non_detected_formats", inline = TRUE),
              )
            ),
          ),
          actionButton("show_files", "Show input status"),
          uiOutput("pd_input_check"),
        ),
        # --- OUTPUT STATUS
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Output directory", class = "rect-title"),
          ),
          uiOutput("pd_output_check")
        ),
        # --- LAYOUT FILE STATUS
        tags$div(
          class = "status-rectangle",
          tags$div(
            class = "content-left",
            tags$h4("Layout file (optional)", class = "rect-title"),
            tags$div(
              class = "rect-values",
              tags$span("Shape: ", ),
              textOutput("pd_layout_shape", inline = TRUE),
              tags$span("", style = "margin-right: 15px;"),
              tags$span("Num wells: "),
              textOutput("pd_layout_n_wells", inline = TRUE),
            )
          ),
          uiOutput("pd_layout_check")
        ),
        tags$hr(),
        h4("Run Status"),
        uiOutput("pd_status"),
        hr(),
        h4("Run Log"),
        verbatimTextOutput("pd_log")
      )
    )
  )
)

ui <- navbarPage(
  "SerolyzeR",
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  single_plate_tab, process_dir_tab
)
