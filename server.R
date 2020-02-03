# Define server logic to read selected file ----
server <- function(input, output) {
        
        output$data_contents <- renderTable({
                
                # input$file1 will be NULL initially. After the user selects
                # and uploads a file, head of that data file by default,
                # or all rows if selected, will be shown.
                
                req(input$file1)
                
                data_df <- read.csv(input$file1$datapath,
                               header = input$header,
                               sep = input$sep,
                               quote = input$quote)
                
                if(input$disp == "head") {
                        return(head(data_df))
                }
                else {
                        return(data_df)
                }
                
        })
        
        output$library_contents <- renderTable({
                
                # input$file1 will be NULL initially. After the user selects
                # and uploads a file, head of that data file by default,
                # or all rows if selected, will be shown.
                
                req(input$file2)
                
                library_df <- read.csv(input$file2$datapath,
                                    header = input$header,
                                    sep = input$sep,
                                    quote = input$quote)
                
                if(input$disp == "head") {
                        return(head(library_df))
                }
                else {
                        return(library_df)
                }
                
        })
        
}