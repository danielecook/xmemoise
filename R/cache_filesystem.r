#' @name cache_filesystem
#' @title Initiate a filesystem cache.
#' @usage
#' cache_filesystem stores cached items within a directory. It can be used with
#' Dropbox or Google Drive to allow for cache access from multiple computers.
#'
#' To use cache_filesystem with Dropbox, you can specify:
#'
#'   cache_filesystem("~/Dropbox/.rcache")
#'
#' For Google Drive:
#'
#'   cache_filesystem("~/Google Drive/.rcache")
#'
#'
#' @param path Directory in which to store cached items.
#'
#'
#' @export

cache_filesystem <- function(path) {

  dir.create(file.path(path), showWarnings = FALSE)

  cache_reset <- function() {
    cache_files <- list.files(path, full.names = TRUE)
    # Use an environment for loaded items.
    cache <<- new.env(TRUE, emptyenv())
    if (length(cache_files) > 0) {
      rm_status <- file.remove(list.files(path, full.names = TRUE))
      if (rm_status) {
        message("Cached files removed.")
      }
    } else {
        message("No files in Cache.")
    }
  }

  cache_set <- function(key, value) {
    save(value, file = paste(path, key, sep="/"))
  }

  cache_get <- function(key) {
    load(file = paste(path, key, sep="/"))
    value
  }

  cache_has_key <- function(key) {
    file.exists(paste(path, key, sep="/"))
  }

  list(
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    keys = function() list.files(path)
  )
}
