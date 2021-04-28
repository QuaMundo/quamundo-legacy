# Environment for quamundo app

##################################################
# Environment: development
##################################################

# These are the default settings used by docker container

# Database settings
export POSTGRES_HOST_DEV=localhost
export POSTGRES_USER_DEV=postgres
export POSTGRES_DB_DEV=quamundo_dev
export POSTGRES_PASSWORD_DEV=Aigh7hi9aesh3oogah3diu9Fiowen4
export POSTGRES_PORT_DEV=55432

# SMTP settings
export SMTP_HOST_DEV=localhost
export SMTP_PORT_DEV=1025
export SMTP_USER_DEV=''
export SMTP_PASSWORD_DEV=''
export SMTP_AUTHENTICATION_DEV=login
export MAIL_SENDER_DEV='mail@example.tld'

##################################################
# Environment: production
##################################################

# Database settings
export POSTGRES_HOST_PRODUCTION=$POSTGRES_HOST_DEV
export POSTGRES_USER_PRODUCTION=$POSTGRES_USER_DEV
export POSTGRES_DB_PRODUCTION=quamundo
export POSTGRES_PASSWORD_PRODUCTION=''
export POSTGRES_PORT_PRODUCTION=5432

# SMTP settings
export SMTP_HOST_PRODUCTION=''
export SMTP_PORT_PRODUCTION=''
export SMTP_USER_PRODUCTION=''
export SMTP_PASSWORD_PRODUCTION=''
export SMTP_AUTHENTICATION_PRODUCTION=''
export MAIL_SENDER_PRODUCTION=''

##################################################
# Environment: test
##################################################

# Database settings
export POSTGRES_HOST_TEST=$POSTGRES_HOST_DEV
export POSTGRES_USER_TEST=$POSTGRES_USER_DEV
export POSTGRES_DB_TEST=quamundo_test
export POSTGRES_PASSWORD_TEST=$POSTGRES_PASSWORD_DEV
export POSTGRES_PORT_TEST=$POSTGRES_PORT_DEV

# SMTP settings
export SMTP_HOST_TEST=$SMTP_HOST_DEV
export SMTP_PORT_TEST=$SMTP_PORT_DEV
export SMTP_USER_TEST=$SMTP_USER_DEV
export SMTP_PASSWORD_TEST=$SMTP_PASSWORD_DEV
export SMTP_AUTHENTICATION_TEST=$SMTP_AUTHENTICATION_DEV
export MAIL_SENDER_TEST=$MAIL_SENDER_DEV

# Overwrite with local vaules
# `cp .env.local.sample .env.local`

[ -f .env.local ] && source .env.local

# vim: set ft=sh:
