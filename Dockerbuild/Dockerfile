FROM rocker/binder:4.4.1

COPY renv.lock renv.lock

RUN mkdir -p /home/rstudio/renv/library

ENV RENV_PATHS_LIBRARY=/home/rstudio/renv/library

RUN install2.r --error --skipinstalled --ncpus -1 renv

RUN R -e 'renv::restore()'

RUN rm -rf /home/rstudio/renv/library/linux-ubuntu-jammy/R-4.4/x86_64-pc-linux-gnu/00LOCK-renv

RUN chown -R rstudio:rstudio /home/rstudio/renv/library

EXPOSE 8888

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser"]
