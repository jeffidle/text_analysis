# Clean text in preparation for text analysis
#---------------------------------------------
text_cleaning_fx <- function(text_df, library_df, library_name_col, library_words_col, text_col, data_clean_tasks) {
        
        df <- text_df %>%
                mutate(record_id = row_number(),
                       text_flag = ifelse(is.na(!!!syms(text_col)), FALSE, TRUE),
                       char_count = nchar(!!!syms(text_col)),
                       word_count = sapply(strsplit(!!!syms(text_col), " "), length) - 1,
                       cleaned_text = text_data_df[[text_col]],
                       cleaned_text_word_count = sapply(strsplit(cleaned_text, " "), length) - 1) %>%
                select(record_id, !!!syms(text_col), cleaned_text, text_flag, char_count, word_count, cleaned_text_word_count)
        
        df$word_count[df$word_count == 0] <- NA
        
        min_cc <- min(df$char_count, na.rm = TRUE)
        max_cc <- max(df$char_count, na.rm = TRUE)
        min_wc <- min(df$word_count, na.rm = TRUE)
        max_wc <- max(df$word_count, na.rm = TRUE)
        
        df <- df %>%
                mutate(char_count_scaled = (char_count - min_cc) / (max_cc - min_cc),
                       word_count_scaled = (word_count - min_wc) / (max_wc - min_wc))
        
        if("clean_numbers" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = replace_number(cleaned_text))
                
        }
        
        if("clean_special_chars" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = gsub("[^a-zA-Z]", " ", cleaned_text))
                
        }
        
        if("clean_abbrev" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = replace_abbreviation(cleaned_text))
                
        }
        
        if("clean_symbols" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = replace_symbol(cleaned_text))
                
        }
        
        if("clean_contractions" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = replace_contraction(cleaned_text))
                
        }
        
        if("clean_lower" %in% data_clean_tasks){
                
                df <- df %>%
                        mutate(cleaned_text = tolower(cleaned_text))
                
        }
        
}

# This function is used to add polarity data to the existing text data
#----------------------------------------------------------------------
polarity_adder_fx <- function(df){
        
        polarity_df <- df %$% polarity(cleaned_text, record_id)
        polarity_df <- as.data.frame(polarity_df[[1]])
        polarity_df <- polarity_df[ , c(1, 3:5)]
        polarity_df$polarity[polarity_df$polarity == "NaN"] <- NA
        names(polarity_df) <- c("record_id", "polarity_score", "positive_words", "negative_words")
        polarity_df$positive_words <- as.character(polarity_df$positive_words)
        polarity_df$negative_words <- as.character(polarity_df$negative_words)
        polarity_df <- polarity_df %>%
                mutate(polarity_score2 = round(polarity_score, 2),
                       pw_cc = nchar(positive_words),
                       nw_cc = nchar(negative_words),
                       positive_words = ifelse(startsWith(positive_words, "c("), substr(positive_words, 3, pw_cc - 1), positive_words),
                       positive_words = ifelse(positive_words == "-", NA, positive_words),
                       negative_words = ifelse(startsWith(negative_words, "c("), substr(negative_words, 3, pw_cc - 1), negative_words),
                       negative_words = ifelse(negative_words %in% c("-", '"'), NA, negative_words),
                       positive_word_count = ifelse(is.na(positive_words), NA, sapply(strsplit(positive_words, ","), length)),
                       negative_word_count = ifelse(is.na(negative_words), NA, sapply(strsplit(negative_words, ","), length))) %>%
                select(record_id, polarity_score, polarity_score2, positive_words, negative_words, positive_word_count, negative_word_count)
        
        min_ps <- min(polarity_df$polarity_score, na.rm = TRUE)
        max_ps <- max(polarity_df$polarity_score, na.rm = TRUE)
        min_pwc <- min(polarity_df$positive_word_count, na.rm = TRUE)
        max_pwc <- max(polarity_df$positive_word_count, na.rm = TRUE)
        min_nwc <- min(polarity_df$negative_word_count, na.rm = TRUE)
        max_nwc <- max(polarity_df$negative_word_count, na.rm = TRUE)
        
        polarity_df <- polarity_df %>%
                mutate(polarity_scaled = (polarity_score - min_ps) / (max_ps - min_ps),
                       positive_word_count_scaled = (positive_word_count - min_pwc) / (max_pwc - min_pwc),
                       negative_word_count_scaled = (negative_word_count - min_nwc) / (max_nwc - min_nwc))
        
        polarity_df$positive_word_count[polarity_df$positive_word_count == 0] <- NA
        polarity_df$negative_word_count[polarity_df$negative_word_count == 0] <- NA
        
        df <- merge(x = df, y = polarity_df, by = "record_id", all.x = TRUE, all.y = FALSE)
        
        return(df)
        
}


# Word count function
word_count_fx <- function(x){
        
        length(unlist(strsplit(str_trim(x), '[[:blank:]]+')))       
        
}

# This function creates the list of words or phrases that need to be displayed
# in the words found fields
#------------------------------------------------------------------------------
display_words <- function(text_corpus, library_words){
        
        # Create unigrams, bigrams, trigrams and quadgrams
        text_unigrams <- if(string.summary(text_corpus)[6] >= 1) {ngram(text_corpus, n = 1)} else {""}
        text_bigrams <- if(string.summary(text_corpus)[6] >= 2) {ngram(text_corpus, n = 2)} else {""}
        text_trigrams <- if(string.summary(text_corpus)[6] >= 3) {ngram(text_corpus, n = 3)} else {""}
        #text_quadgrams <- if(string.summary(text_corpus)[6] >= 4) {ngram(text_corpus, n = 4)} else {""}
        
        # Convert ngram output to vectors
        unigrams_vector <- if(string.summary(text_corpus)[6] >= 1) {get.ngrams(text_unigrams)} else {""}
        bigrams_vector <- if(string.summary(text_corpus)[6] >= 2) {get.ngrams(text_bigrams)} else {""}
        trigrams_vector <- if(string.summary(text_corpus)[6] >= 3) {get.ngrams(text_trigrams)} else {""}
        #quadgrams_vector <- if(string.summary(text_corpus)[6] >= 4) {get.ngrams(text_quadgrams)} else {""}
        
        # Combine vectors
        words <- c(unigrams_vector, bigrams_vector, trigrams_vector)
        
        # Find ngrams in text
        txt <- paste(words[words %in% library_words], collapse = "; ")
        
        return(txt)
        
} 


# This function searches the text for the terms found in a single library
#-------------------------------------------------------------------------------
text_search_fx <- function(text_df, library_df, library_name){
        
        library_words <- library_df %>%
                filter(library_df[[library_name_col]] == library_name) %>%
                select(!!!syms(library_words_col)) %>%
                unique() %>%
                arrange(!!!syms(library_words_col))
        
        library_flag_label <- paste0(library_name, "_library_flag")
        library_words_label <- paste0(library_name, "_library_words")
        library_count_label <- paste0(library_name, "_library_words_dcount")
        library_scount_label <- paste0(library_name, "_library_words_count_scaled")
        
        text_df$cleaned_text[is.na(text_df$cleaned_text)] <- "EMPTY"
        
        df <- bind_cols(text_df, as.data.frame(sapply(as.character(text_df$cleaned_text), display_words, as.character(library_words[[library_words_col]]))))
        colnames(df)[ncol(df)] <- "library_words_found_distinct"
        df$library_words_found_distinct[df$library_words_found_distinct == ""] <- NA
        
        df <- df %>%
                mutate(library_words_found_flag = ifelse(is.na(df$library_words_found_distinct), FALSE, TRUE),
                       library_words_found_dcount = ifelse(library_words_found_flag == TRUE, sapply(strsplit(as.character(library_words_found_distinct), "; "), length), NA)) %>%
                select(record_id, library_words_found_flag, library_words_found_distinct, library_words_found_dcount)
        
        df$library_words_found_flag[is.na(df$library_words_found_flag)] <- NA
        
        min_lwc <- min(df$library_words_found_dcount, na.rm = TRUE)
        max_lwc <- max(df$library_words_found_dcount, na.rm = TRUE)
        
        df <- df %>%
                mutate(library_words_count_scaled = (library_words_found_dcount - min_lwc) / (max_lwc - min_lwc))
        
        names(df) <- c("record_id", library_flag_label, library_words_label, library_count_label, library_scount_label)
        
        return(df)
        
}


# This function searches the text for the terms found in all of the uploaded libraries
#--------------------------------------------------------------------------------------
text_search_bulk_fx <- function(text_df, library_df){
        
        library_list <- unlist(library_df %>%
                                       select(!!!syms(library_name_col)) %>%
                                       unique() %>%
                                       arrange(!!!syms(library_name_col)))
        
        for(x in library_list){
                
                temporary_df <- text_search_fx(text_df, library_data_df, x)
                
                if(exists("library_reviewed_df")){
                        
                        library_reviewed_df <- bind_cols(library_reviewed_df, temporary_df[ , c(2:5)])
                        
                } else {
                        
                        library_reviewed_df <- temporary_df
                        
                }
                
        }
        
        return(library_reviewed_df)
        
}


# This function provides a summary of columns that have binary values
#---------------------------------------------------------------------
flag_summary_fx <- function(df, flag_metric){
        
        summary_df <- df %>%
                group_by(!!!syms(flag_metric)) %>%
                count() %>%
                ungroup() %>%
                mutate(metric = flag_metric,
                       pct_of_total = round(n / total_records, 2))
        
        names(summary_df) <- c("category", "count", "metric", "pct_of_total")
        
        summary_df <- summary_df %>%
                select(metric, category, count, pct_of_total)
        
        summary_df$category <- as.character(summary_df$category)
        
        return(summary_df)
        
}
