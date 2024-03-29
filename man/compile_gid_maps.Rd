% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compile_gid_maps.R
\name{compile_gid_maps}
\alias{compile_gid_maps}
\title{Build a map between GIDs and PIDs}
\usage{
compile_gid_maps(path, mode = "onlyfocal")
}
\arguments{
\item{path}{Path to RICH folder.}

\item{mode}{For games like the PGG or SnowDrift, where the focal persons can either give or not, set to "onlyfocal". For games were the focal
can give to anyone on the roster, set to "fullset".}
}
\description{
This is a small helper function to create suveys JSON files that guide the app behavior.
}
