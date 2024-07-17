FROM ghcr.io/e-kotov/mitma-data-issues:202407172026

COPY --chown=${NB_USER} . ${HOME}
