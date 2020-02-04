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
                                              multiple = TRUE,
                                              accept = c("text/csv",
                                                         "text/comma-separated-values,text/plain",
                                                         ".csv",
                                                         ".xlsx")),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
                                    # Input: Checkbox if file has header ----
                                    checkboxInput("header1", "Header", TRUE),
                                    
                                    # Input: Select separator ----
                                    radioButtons("filetype1", "File Type",
                                                 choices = c("CSV" = "CSV",
                                                             "XLSX" = "XLSX"),
                                                 selected = "CSV"),
                                    
                                    # Input: Select quotes ----
                                    radioButtons("quote1", "Quote",
                                                 choices = c(None = "",
                                                             "Double Quote" = '"',
                                                             "Single Quote" = "'"),
                                                 selected = '"'),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
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
                                              multiple = TRUE,
                                              accept = c("text/csv",
                                                         "text/comma-separated-values,text/plain",
                                                         ".csv",
                                                         ".xlsx")),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
                                    # Input: Checkbox if file has header ----
                                    checkboxInput("header2", "Header", TRUE),
                                    
                                    # Input: Select separator ----
                                    radioButtons("filetype2", "File Type",
                                                 choices = c("CSV" = "CSV",
                                                             "XLSX" = "XLSX"),
                                                 selected = "CSV"),
                                    
                                    # Input: Select quotes ----
                                    radioButtons("quote2", "Quote",
                                                 choices = c(None = "",
                                                             "Double Quote" = '"',
                                                             "Single Quote" = "'"),
                                                 selected = '"'),
                                    
                                    # Horizontal line ----
                                    tags$hr(),
                                    
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
                    
                    tabPanel("(3) Choose how you want to map and clean your data >>",
                             
                             column(6, selectInput("library_name", "Select the column that contains the names of your libraries:", choices = "")),
                             column(6, selectInput("library_terms", "Select the column that contains your library terms:", choices = ifelse(exists("library_df"), sort(names(library_df)), "Please upload your library"))),
                             column(6, selectInput("unique_id", "Select the unique record identifier in your data:", choices = ifelse(exists("data_df"), sort(names(data_df)), "Please upload your data"))),
                             column(6, selectInput("text_data", "Select the text you want to analyze:", choices = ifelse(exists("data_df"), sort(names(data_df)), "Please upload your data"))),
                             column(12, checkboxGroupInput("data_cleaning", "Choose the data cleansing functions you want to apply to your data:", 
                                                    c("Convert to lowercase", "Replace abbreviations", "Replace numbers", "Replace symbols", "Remove contractions")))),
                    
                    tabPanel("(4) View output >>", "For each comment:  character count, word count, polarity score, negative words, positive words, library word flag, library word count, library words found, risk scale (0-1)"),
                    
                    tabPanel("(5) Output summary", "Output summary by dictionary")
                    
        )
        
)