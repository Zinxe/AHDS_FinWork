#!/bin/bash

echo "Downloading PubMed IDs..."
curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > raw/pmids.xml

echo "Extracting PubMed IDs..."
pmids=$(grep -oP '(?<=<Id>)[0-9]+(?=</Id>)' raw/pmids.xml)

echo "Downloading article metadata..."
for pmid in $pmids; do
    echo "Processing PMID: $pmid"
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > raw/article-data-${pmid}.xml
    sleep 1
done

echo "All data downloaded successfully!"
