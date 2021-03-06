getConsoleLines = function(default = 40)
{
    term = Sys.getenv("TERM")
    tput = Sys.which('tput')
    if ( nchar(tput) > 0 && nchar(term) > 0 )
    {
        res = system(paste(tput, "lines"), intern = TRUE)
        if ( is.null(attr(res, "status")) ) lines = as.integer(res)
        else lines = default
    }
    else
        lines = default
    return(lines)
}

getConsoleCols = function(default = 80)
{
  term = Sys.getenv("TERM")
  tput = Sys.which('tput')
  if ( nchar(tput) > 0 && nchar(term) > 0 )
  {
    res = system(paste(tput, "cols"), intern = TRUE)
    if ( is.null(attr(res, "status")) )  lines = as.integer(res)
    else lines = default
  }
  else
    lines = default
  return(lines)
}

catLines = function(x)
{
    max.lines = getConsoleLines()
    max.chars = getConsoleCols()
    for ( i in 1L:length(x) ) 
    {
        if ( i > max.lines - 4 )
        {
            cat("Truncated...\n")
            break;
        }
        out = encodeString(x[i])
        if ( nchar(out, "width") > max.chars - 4 )
        {
          out = substr(out, 0, max.chars - 8)
          out = paste(out, "...")
        }
        cat(out, '\n')
    }
}

assertClass = function(x, class)
{
    stopifnot(inherits(x, class))
}

fetchUSStates = function(resolution = c("20m", "5m", "500k"),
                         destdir = tempdir(),
                         unlink = TRUE)
{
    resolution = match.arg(resolution)
    if ( unlink ) on.exit(unlink(destdir))
    base_url = "http://www2.census.gov/geo/tiger"
    subdir = "GENZ2010"
    file_base = paste("gz", "2010", "us", "040", "00", resolution, sep = "_")
    file = paste0(file_base, ".zip")
    file_url = paste(base_url, subdir, file, sep = "/")
    dest_file = paste(destdir, file, sep = "/")
    download.file(file_url, dest_file, mode = "wb")
    unzip(dest_file, exdir = destdir)
    openOGR(paste(destdir, paste0(file_base, ".shp"), sep = "/"))
}

print.formatted.text = function(x)
{
    cat(x, "\n")
    invisible(x)
}

'%ifNull%' = function(lhs, rhs) ifelse(is.null(lhs), rhs, lhs)


