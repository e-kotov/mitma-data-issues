FROM ghcr.io/e-kotov/mitma-data-issues:202407171744

COPY --chown=${NB_USER} . ${HOME}
