# Environment for quamundo app

##################################################
# Environment: production
##################################################

# These are the default settings used by docker container

# Database settings
export POSTGRES_HOST_PRODUCTION=localhost
export POSTGRES_USER_PRODUCTION=postgres
export POSTGRES_DB_PRODUCTION=quamundo
export POSTGRES_PASSWORD_PRODUCTION=Aigh7hi9aesh3oogah3diu9Fiowen4
export POSTGRES_PORT_PRODUCTION=55432

# SMTP settings
export SMTP_HOST_PRODUCTION=localhost
export SMTP_PORT_PRODUCTION=1025
export SMTP_USER_PRODUCTION=
export SMTP_PASSWORD_PRODUCTION=
export SMTP_AUTHENTICATION_PRODUCTION=login
export MAIL_SENDER_PRODUCTION='mail@example.tld'

##################################################
# Environment: development
##################################################

# Database settings
export POSTGRES_HOST_DEV=$POSTGRES_HOST_PRODUCTION
export POSTGRES_USER_DEV=$POSTGRES_USER_PRODUCTION
export POSTGRES_DB_DEV=quamundo_dev
export POSTGRES_PASSWORD_DEV=$POSTGRES_PASSWORD_PRODUCTION
export POSTGRES_PORT_DEV=$POSTGRES_PORT_PRODUCTION

# SMTP settings
export SMTP_HOST_DEV=$SMTP_HOST_PRODUCTION
export SMTP_PORT_DEV=$SMTP_PORT_PRODUCTION
export SMTP_USER_DEV=$SMTP_USER_PRODUCTION
export SMTP_PASSWORD_DEV=$SMTP_PASSWORD_PRODUCTION
export SMTP_AUTHENTICATION_DEV=$SMTP_AUTHENTICATION_PRODUCTION
export MAIL_SENDER_DEV=$MAIL_SENDER_PRODUCTION

##################################################
# Environment: test
##################################################

# Database settings
export POSTGRES_HOST_TEST=$POSTGRES_HOST_PRODUCTION
export POSTGRES_USER_TEST=$POSTGRES_USER_PRODUCTION
export POSTGRES_DB_TEST=quamundo_test
export POSTGRES_PASSWORD_TEST=$POSTGRES_PASSWORD_PRODUCTION
export POSTGRES_PORT_TEST=$POSTGRES_PORT_PRODUCTION

# SMTP settings
export SMTP_HOST_TEST=$SMTP_HOST_PRODUCTION
export SMTP_PORT_TEST=$SMTP_PORT_PRODUCTION
export SMTP_USER_TEST=$SMTP_USER_PRODUCTION
export SMTP_PASSWORD_TEST=$SMTP_PASSWORD_PRODUCTION
export SMTP_AUTHENTICATION_TEST=$SMTP_AUTHENTICATION_PRODUCTION
export MAIL_SENDER_TEST=$MAIL_SENDER_PRODUCTION

# Overwrite with local vaules
# `cp .env.local.sample .env.local`

[ -f .env.local ] && source .env.local

# vim: set ft=sh:
