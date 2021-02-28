update 
    crates 
set 
    latest_version_id = (
        select 
            id 
        from releases as r 
        where r.crate_id = crates.id 
        order by version desc 
        limit 1
    )
;

