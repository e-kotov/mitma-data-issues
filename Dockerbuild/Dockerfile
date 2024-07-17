FROM rocker/binder:4.4.1

COPY renv.lock renv.lock

RUN install2.r --error --skipinstalled --ncpus -1 renv && \
    R -e 'renv::activate()' \
    R -e 'renv::restore()'
