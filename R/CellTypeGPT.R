#' Annotate Cell Types using Custom GPT
#'
#' This function annotates cell types based on input gene markers.
#'
#' @param input A list or data frame containing gene markers.
#' @param tissuename A character string specifying the tissue name.
#' @param model A character string specifying the model to use.
#' @param topgenenumber An integer specifying the number of top genes to consider.
#' @param api_base A character string specifying the base URL for the API.
#' @return A character vector of annotated cell types.
#' @export
#' @name annotate_cell_types
#' @examples
#' # Example usage:
#' # annotate_cell_types(input = my_gene_data, tissuename = "liver", model = "gpt-4o", topgenenumber = 10, api_base = "https://api.default.com/v1/chat/completions")

library(httr2)


annotate_cell_types <- function(input, tissuename = NULL, model = 'gpt-4o', topgenenumber = 10, api_base) {
  OPENAI_API_KEY <- Sys.getenv("OPENAI_API_KEY")

  if (OPENAI_API_KEY == "") {
    stop("OpenAI API key not found. Please set your API key in the environment.")
  }


  if (class(input) == 'list') {
    input <- sapply(input, paste, collapse = ',')
  } else {
    input <- input[input$avg_log2FC > 0, , drop = FALSE]
    input <- tapply(input$gene, list(input$cluster), function(i) paste0(i[1:topgenenumber], collapse = ','))
  }

  cutnum <- ceiling(length(input) / 30)
  if (cutnum > 1) {
    cid <- as.numeric(cut(1:length(input), cutnum))
  } else {
    cid <- rep(1, length(input))
  }

  allres <- sapply(1:cutnum, function(i) {
    id <- which(cid == i)
    flag <- 0
    while (flag == 0) {

      req <- request(api_base) %>%
        req_method("POST") %>%
        req_headers(
          "Authorization" = paste("Bearer", OPENAI_API_KEY),
          "Content-Type" = "application/json"
        ) %>%
        req_body_json(list(
          model = model,
          messages = list(list(
            role = "user",
            content = paste0('You are an expert in cell biology. Identify cell types of ', tissuename, ' cells using the following markers separately for each\n row. Only provide the cell type name. Do not show numbers or additional text before the name.\n Some can be a mixture of multiple cell types.\n', paste(input[id], collapse = '\n'))
          ))
        ))


      resp <- req_perform(req)

      content <- resp_body_json(resp)
      res <- strsplit(content$choices[[1]]$message$content, '\n')[[1]]

      if (length(res) == length(id)) {
        flag <- 1
      }
    }
    names(res) <- names(input)[id]
    res
  }, simplify = FALSE)
  print('DONE.')
  return(gsub(',$', '', unlist(allres)))
}

