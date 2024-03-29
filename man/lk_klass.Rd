% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lk_klass.R
\name{lk_klass}
\alias{lk_klass}
\title{Classification and filtering of symptom diary entries}
\usage{
lk_klass(lk_dat, lebmon_min, lebmon_max, f_niedrig, f_hoch)
}
\arguments{
\item{lk_dat}{Input data set (Loewenkids symptom diary)}

\item{lebmon_min}{Minimum month of life}

\item{lebmon_max}{Maximum month of life}

\item{f_niedrig}{Low fever cut off}

\item{f_hoch}{High fever cut off}
}
\value{
A data.frame including the original symptom diary and the additional columns
}
\description{
lk_klass() filters records for each id_s in the symptom diary according to a predefined duration (months of living) and classifies each entry according to predefined fever categories. In addition, age (in days as well as in months of life) for each individual are calculated.
}
\examples{
lk_klass()
}
\keyword{classification}
\keyword{diary}
\keyword{fever}
\keyword{life}
\keyword{months}
\keyword{of}
\keyword{symptom}
