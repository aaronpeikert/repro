FROM rocker/{{{stack}}}:{{{rver}}}
WORKDIR /home/rstudio
RUN apt-get update -y && apt-get install -y rsync
RUN tlmgr install collection-latexrecommended
