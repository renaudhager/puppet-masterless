# profiles::pulp::rpm_repos

class profiles::pulp::rpm_repos (
  ) {

    $repos = hiera_hash( 'profiles::pulp::rpm_repos::repos', {} )
    validate_hash( $repos )

    create_resources( profiles::pulp::rpm_repo, $repos )

}
