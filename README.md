CellTypeGPT: Automatic cell type annotation with custom GPT
====

## Installation 

To install the latest version of CellTypeGPT package via Github, run the following commands in R:
```{r eval = FALSE}
remotes::install_github("XWcode11/CellTypeGPT")
```

##  🚀 Quick start with Seurat pipeline 


```{r eval = FALSE}

# IMPORTANT! Assign your OpenAI API key. See Vignette for details
Sys.setenv(OPENAI_API_KEY = 'your_openai_API_key')

# Load packages
library(CellTypeGPT)


# Assume you have already run the Seurat pipeline https://satijalab.org/seurat/
# "obj" is the Seurat object; "markers" is the output from FindAllMarkers(obj)
# Cell type annotation by custom GPT
res <- annotate_cell_types(af.markers,tissuename='liver cancer', model = 'gpt-4o', topgenenumber=50, api_base = 'https://custom.url/v1/chat/completions')

# Assign cell type annotation back to Seurat object
obj@meta.data$celltype <- as.factor(res[as.character(Idents(obj))])

# Visualize cell type annotation on UMAP
DimPlot(obj,group.by='celltype')
```

