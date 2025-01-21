-- status 2024-11-08: 108696
-- status 2024-11-11: 101949
-- status 2024-11-13: 93795
-- status 2024-11-14: 89810
-- status 2024-11-15: 85609
-- status 2024-11-17: 77512
-- status 2024-11-18: 73939
-- status 2025-01-14: 64809
-- status 2025-01-15: 63344
-- status 2025-01-16: 61372
-- status 2025-01-17: 58684
-- status 2025-01-20: 47482
SELECT count(*) FROM (
     SELECT
         c.name,
         r.version,
         (
            SELECT MAX(b.rustc_nightly_date)
            FROM builds AS b
            WHERE b.rid = r.id AND b.rustc_nightly_date IS NOT NULL
         ) AS rustc_nightly_date,
         (
            SELECT MAX(COALESCE(b.build_finished, b.build_started))
            FROM builds AS b
            WHERE b.rid = r.id
         ) AS last_build_attempt
     FROM crates AS c
     INNER JOIN releases AS r ON c.latest_version_id = r.id

     WHERE
         r.rustdoc_status = TRUE
 ) as i
 WHERE i.rustc_nightly_date < '2024-10-01' AND i.last_build_attempt < '2024-10-01'
;
