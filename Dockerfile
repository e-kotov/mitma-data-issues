FROM ghcr.io/e-kotov/mitma-data-issues:latest

COPY --chown=${NB_USER} . ${HOME}
