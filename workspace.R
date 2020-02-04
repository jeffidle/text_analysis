library(ngram)
library(qdap)
library(tidyverse)

text_data_df <- read.csv("text_complaints_small.csv", header = TRUE, stringsAsFactors = FALSE, na.strings = c("", " ", "  ", "   ", "    ", "-", "N/A", "#N/A", "n/a", "#n/a"))
library_data_df <- read.csv("text_analysis_library.csv", header = TRUE, stringsAsFactors = FALSE)

library_name_col <- "library"
library_words_col <- "keyword_phrase"
text_col <- "Consumer.complaint.narrative"

clean_special_chars <- 0
clean_lower <- 0
clean_abbrev <- 0
clean_numbers <- 0
clean_symbols <- 1
clean_contractions <- 0

# Text cleaners

df <- text_data_df %>%
        mutate(record_id = row_number(),
               text_flag = ifelse(is.na(!!!syms(text_col)), FALSE, TRUE),
               char_count = nchar(!!!syms(text_col)),
               word_count = sapply(strsplit(!!!syms(text_col), " "), length) - 1,
               cleaned_text = text_data_df[[text_col]]) %>%
        select(record_id, !!!syms(text_col), cleaned_text, text_flag, char_count, word_count)

if(clean_special_chars == 1){
        
        df <- df %>%
                mutate(cleaned_text = gsub("[^a-zA-Z]", " ", cleaned_text))
        
}

if(clean_lower == 1){
        
        df <- df %>%
                mutate(cleaned_text = tolower(cleaned_text))
        
}

if(clean_abbrev == 1){
        
        df <- df %>%
                mutate(cleaned_text = replace_abbreviation(cleaned_text))
        
}

if(clean_numbers == 1){
        
        df <- df %>%
                mutate(cleaned_text = replace_number(cleaned_text))
        
}

if(clean_symbols == 1){
        
        df <- df %>%
                mutate(cleaned_text = replace_symbol(cleaned_text))
        
}

if(clean_contractions == 1){
        
        df <- df %>%
                mutate(cleaned_text = replace_contraction(cleaned_text))
        
}
