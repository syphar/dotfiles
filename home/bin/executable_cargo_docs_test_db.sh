#!/bin/bash
set -euxo pipefail

source=postgres://syphar@localhost/cargo_registry
dest=postgres://syphar@localhost/cratesfyi

psql -c "truncate table crates cascade" $dest
psql -c "\copy crates(id,name) to STDOUT" $source | psql -c "\copy crates (id, name) from STDIN" $dest

psql -c "\copy (select c.id, v.num, v.created_at, 'dummy_target', c.repository, 'nightly', true, 'default' from versions as v inner join crates as c on v.crate_id = c.id) to STDOUT" $source | psql -c "\copy releases(crate_id,version,release_time,target_name,repository_url,doc_rustc_version,rustdoc_status,default_target) from STDIN" $dest

psql $dest < cargo_docs_test_db.sql
