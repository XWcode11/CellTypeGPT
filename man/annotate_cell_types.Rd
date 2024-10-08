% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CellTypeGPT.R
\name{annotate_cell_types}
\alias{annotate_cell_types}
\title{Annotate Cell Types using Custom GPT}
\arguments{
\item{input}{A list or data frame containing gene markers.}

\item{tissuename}{A character string specifying the tissue name.}

\item{model}{A character string specifying the model to use.}

\item{topgenenumber}{An integer specifying the number of top genes to consider.}

\item{api_base}{A character string specifying the base URL for the API.}
}
\value{
A character vector of annotated cell types.
}
\description{
This function annotates cell types based on input gene markers.
}
\examples{
# Example usage:
# annotate_cell_types(input = my_gene_data, tissuename = "liver", model = "gpt-4o", topgenenumber = 10, api_base = "https://api.default.com/v1/chat/completions")
}
