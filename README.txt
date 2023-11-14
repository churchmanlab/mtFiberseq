This repository contains the scripts necessary to analyze mtFiber-seq data, as performed in the manuscript "Single-nucleoid architecture reveals heterogeneous packaging of mitochondrial DNA".

Contents:

	1) ATACsee

		Contains Fiji macros.

	2) ATACseq

		Contains scripts used to align and process ATAC-seq data

	3) CHIPseq

		Contains scripts used to process ChIP-seq data from Jemt et al., 2015

	4) downstream_analyses

		Contains scripts used for downstream analyses of PacBio methylation
		data and footprinting outputs

	5) footprintCalling

		Contains the scripts and instructions needed to run the HMM for identifying
		footprints and accessible DNA from mtFiber-seq reads

	6) PacBio_alignment_m6Acalling

		Contains the full pipeline to align PacBio subreads and call 
		adenine methylation using a combination of SMRT Tools and Fibertools

	7) referenceGenomes

		Contains the reference genome .fa files used for ATAC-seq
		and mtFiber-seq (PacBio) alignment
