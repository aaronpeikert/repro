automate_docker <- function(path = "."){
  if(automate_dir()){
    dockerfile_base <- paste0(getOption("repro.dir"),
                              "/",
                              getOption("repro.dockerfile.base"))
    dockerfile_packages <- paste0(getOption("repro.dir"),
                                  "/",
                                  getOption("repro.dockerfile.packages"))
    dockerfile_manual <- paste0(getOption("repro.dir"),
                                "/",
                                getOption("repro.dockerfile.manual"))
    # handle base
    if(!fs::file_exists(dockerfile_base))use_docker(file = dockerfile_base,
                                                    open = FALSE)
    # handle packages
    docker_packages <- use_docker_packages(
      yamls_packages(path = usethis::proj_path(path)),
      file = dockerfile_base,
      write = FALSE,
      append = FALSE
    )
    xfun::write_utf8(docker_packages, dockerfile_packages)
    # handle manual
    if(!fs::file_exists(dockerfile_manual))fs::file_create(dockerfile_manual)
  }
}

automate_dir <- function(dir, warn = FALSE, create = !warn){
  if(missing(dir))dir <- getOption("repro.dir")
  dir_full <- usethis::proj_path(dir)
  exists <- fs::dir_exists(dir_full)
  if(!exists){
    if(warn){
      usethis::ui_oops("Directory {usethis::ui_code(dir)} does not exist!")
    }
    if(create){
      fs::dir_create(dir_full)
      usethis::ui_done("Directory {usethis::ui_code(dir)} created!")
      exists <- TRUE
    }
  }
  return(exists)
}
