FROM rocker/binder:4.4.1

COPY renv.lock renv.lock

RUN install2.r --error --skipinstalled --ncpus -1 renv

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e 'renv::restore()'
