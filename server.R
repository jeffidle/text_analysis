# Define server logic to read selected file ----
server <- function(input, output, session) {
        
        text_data <- reactive({
                
                # input$file1 will be NULL initially. After the user selects
                # and uploads a file, head of that data file by default,
                # or all rows if selected, will be shown.
                
                req(input$file1)
                
                if(input$filetype1 == "CSV"){
                        
                        data_df <- read.csv(input$file1$datapath,
                                               header = input$header1,
                                               stringsAsFactors = FALSE,
                                               sep = ",",
                                               quote = input$quote1)
                        
                } else {
                        
                        data_df <- read_xlsx(input$file1$datapath,
                                                col_names = input$header1,
                                                trim_ws = TRUE)
                        
                }
                
                if(input$disp1 == "head") {
                        return(head(data_df))
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
                                               header = input$header2,
                                               stringsAsFactors = FALSE,
                                               sep = ",",
                                               quote = input$quote2)
                                
                } else {
                        
                        library_df <- read_xlsx(input$file2$datapath,
                                               col_names = input$header2,
                                               trim_ws = TRUE)
                        
                }
                
                
                if(input$disp2 == "head") {
                        return(head(library_df))
                }
                else {
                        return(library_df)
                }
                
        })
        
        output$library_contents <- renderTable({
                
                options(shiny.maxRequestSize = 30*1024^2)
                
                library_data()
                
        })
        
        observe({
                updateSelectInput(session, "library_name",
                                  label = "library_name",
                                  choices = library_data()$names,
                                  selected = library_data()$names[1])
        })
        
}