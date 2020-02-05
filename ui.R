# Define UI for data upload app ----
ui <- fluidPage(
        
        # Define server logic to read selected file ----
        titlePanel("Analyze your text"),
        
        tabsetPanel(type = "tabs",
                    tabPanel("(1) Load your data >>", sidebarLayout(
                            
                            # Sidebar panel for inputs ----
                            sidebarPanel(
                                    
                                    # Input: Select a file ----
                                    fileInput("file1", "Choose CSV or XLSX data file",
                                              multiple = FALSE,
                                              accept = c("text/csv",
                                                         "text/comma-separated-values,text/plain",
                                                         ".csv",
                                                         ".xlsx")),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
                                    # Input: Select separator ----
                                    radioButtons("filetype1", "File Type",
                                                 choices = c("CSV" = "CSV",
                                                             "XLSX" = "XLSX"),
                                                 selected = NULL),
                                    
                                    # Input: Select number of rows to display ----
                                    radioButtons("disp1", "Display",
                                                 choices = c(Head = "head",
                                                             All = "all"),
                                                 selected = "head")
                                    
                            ),
                            
                            # Main panel for displaying outputs ----
                            mainPanel(
                                    
                                    # Output: Data file ----
                                    tableOutput("data_contents")
                                    
                            )
                            
                    )),
                    
                    tabPanel("(2) Load your library >>", sidebarLayout(
                            
                            # Sidebar panel for inputs ----
                            sidebarPanel(
                                    
                                    # Input: Select a file ----
                                    fileInput("file2", "Choose CSV or XLSX library file",
                                              multiple = FALSE,
                                              accept = c("text/csv",
                                                         "text/comma-separated-values,text/plain",
                                                         ".csv",
                                                         ".xlsx")),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
                                    # Input: Select separator ----
                                    radioButtons("filetype2", "File Type",
                                                 choices = c("CSV" = "CSV",
                                                             "XLSX" = "XLSX"),
                                                 selected = NULL),
                                    
                                    # Input: Select number of rows to display ----
                                    radioButtons("disp2", "Display",
                                                 choices = c(Head = "head",
                                                             All = "all"),
                                                 selected = "head")
                                    
                            ),
                            
                            # Main panel for displaying outputs ----
                            mainPanel(
                                    
                                    # Output: Data file ----
                                    tableOutput("library_contents")
                                    
                            )
                            
                    )),
                    
                    tabPanel("(3) Process your data >>",
                             
                             sidebarPanel(
                                     
                                     uiOutput("library_name_select"),
                                     
                                     uiOutput("library_words_select"),
                                     
                                     uiOutput("data_text_select"),
                                     
                                     checkboxGroupInput("data_cleaning", "Choose the data cleansing functions you want to apply to your data:", 
                                                        c("Remove special characters" = "clean_special_chars",
                                                          "Convert to lowercase" = "clean_lower",
                                                          "Replace abbreviations" = "clean_abbrev",
                                                          "Replace numbers" = "clean_numbers",
                                                          "Replace symbols" = "clean_symbols",
                                                          "Remove contractions" = "clean_contractions")),
                                     
                                     actionButton("process_data", "Process my data")
                                     
                             ),
                             
                             mainPanel(
                                     
                                     tableOutput("processed_data")
                                     
                                     )
                             
                             ),
                    
                    tabPanel("(4) View output >>", "For each comment:  character count, word count, polarity score, negative words, positive words, library word flag, library word count, library words found, risk scale (0-1)"),
                    
                    tabPanel("(5) Output summary", "Output summary by dictionary"),
                    
                    tabPanel("(6) Correlation analysis", "Show correlation matrix for all metrics (character count, word count, polarity score, negative word count, positive word count, library word count and risk scale converted to 0-1 scale) and allow user to select 2 metrics and view scatterplot with regression line.")
                    
        )
        
)