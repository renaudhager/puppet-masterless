# profiles::mongodb::dbs
#
# Create a DB
#
# Require module puppetlabs/mongodb
#
define profiles::mongodb::db (
  $db_name = $name,
  $tries   = 10,

) {

  mongodb_database { $db_name:
    ensure => present,
    tries  => $tries
  }

}
