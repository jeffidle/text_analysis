library(GGally)
library(magrittr)
library(ngram)
library(qdap)
library(tidyverse)

source("functions.R")

script_start <- Sys.time()

text_data_df <- read.csv("text_complaints_small.csv", header = TRUE, stringsAsFactors = FALSE, na.strings = c("", " ", "  ", "   ", "    ", "-", "N/A", "#N/A", "n/a", "#n/a"))
library_data_df <- read.csv("text_analysis_library.csv", header = TRUE, stringsAsFactors = FALSE)

library_name_col <- "library"
library_words_col <- "keyword_phrase"
text_col <- "Consumer.complaint.narrative"

#data_clean_tasks <- c("clean_special_chars", "clean_lower", "clean_abbrev", "clean_numbers", "clean_symbols", "clean_contractions")

data_clean_tasks <- c("clean_lower")

processed_df <- text_cleaning_fx(text_data_df, library_data_df, library_name_col, library_words_col, text_col, data_clean_tasks)

text_df <- processed_df

text_df <- sample_n(processed_df, 1000)

processed_w_polarity_df <- polarity_adder_fx(text_df)

library_reviewed_df <- text_search_bulk_fx(text_df, library_data_df)

processed_w_polarity_df <- merge(x = processed_w_polarity_df, y = library_reviewed_df, by = "record_id", all.x = TRUE, all.y = FALSE)

###################################################################
# Output summary
###################################################################

total_records <- nrow(processed_w_polarity_df)

summary_df <- data.frame(
        
        metric = "total_records",
        category = "all",
        count = total_records,
        pct_of_total = 1
)

flag_metrics <- names(processed_w_polarity_df %>% select(contains("flag")))

for(x in flag_metrics){
        
        flag_summary_df <- flag_summary_fx(processed_w_polarity_df, x)
        summary_df <- bind_rows(summary_df, flag_summary_df)
        
}

viz_df <- processed_w_polarity_df %>%
        select(char_count_scaled, word_count_scaled, polarity_scaled, positive_word_count_scaled, negative_word_count_scaled, deception_library_words_count_scaled, rude_library_words_count_scaled)

ggpairs(viz_df, title="correlogram with ggpairs()")


script_end <- Sys.time()
elapsed_time <- script_end - script_start
