# Define server logic to read selected file ----
server <- function(input, output) {
        
        text_data <- reactive({
                
                # input$file1 will be NULL initially. After the user selects
                # and uploads a file, head of that data file by default,
                # or all rows if selected, will be shown.
                
                req(input$file1)
                
                if(input$filetype1 == "CSV"){
                        
                        data_df <- read.csv(input$file1$datapath,
                                               header = TRUE,
                                               stringsAsFactors = FALSE)
                        
                } else {
                        
                        data_df <- read_xlsx(input$file1$datapath,
                                             col_names = TRUE,
                                             trim_ws = TRUE)
                        
                }
                
                text_df <<- data_df
                
                if(input$disp1 == "head") {
                        
                        return(head(data_df, 10))
                        
                }
                
                else {
                        
                        return(data_df)
                        
                }
        })
        
        output$data_contents <- renderTable({
                
                options(shiny.maxRequestSize = 1000*1024^2)
                text_data()    
                
        })
        
        library_data <- reactive({
                
                # input$file1 will be NULL initially. After the user selects
                # and uploads a file, head of that data file by default,
                # or all rows if selected, will be shown.
                
                req(input$file2)
                
                if(input$filetype2 == "CSV"){
                        
                        library_df <- read.csv(input$file2$datapath,
                                               header = TRUE,
                                               stringsAsFactors = FALSE)
                                
                } else {
                        
                        library_df <- read_xlsx(input$file2$datapath,
                                               col_names = TRUE,
                                               trim_ws = TRUE)
                        
                }
                
                library_df <<- library_df
                
                if(input$disp2 == "head") {
                        
                        return(head(library_df, 10))
                }
                
                else {
                        
                        return(library_df)
                        
                }
                
        })
        
        output$library_contents <- renderTable({
                
                options(shiny.maxRequestSize = 30*1024^2)
                
                library_data()
                
        })
        
        output$library_name_select <- renderUI({
                
                library_names_list <- names(library_data())
                
                selectInput("library_name", "Select the column that contains the names of your libraries:",
                            choices = library_names_list,
                            selected = NULL)
                
        })
        
        output$library_words_select <- renderUI({
                
                library_names_list <- names(library_data())
                
                selectInput("library_words", "Select the column that contains your library terms:",
                            choices = library_names_list,
                            selected = NULL)
                
        })
        
        output$data_text_select <- renderUI({
                
                data_names_list <- names(text_data())
                
                selectInput("data_text", "Select the text you want to analyze:",
                            choices = data_names_list,
                            selected = NULL)
                
        })
        
        output$processed_data <- renderTable({
                
                processed_df <- text_cleaning_fx(text_df, library_df, input$library_name_select, input$library_words_select, input$data_text_select, input$data_cleaning)
                
        })
        
}