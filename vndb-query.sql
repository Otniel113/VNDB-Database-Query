-- ===================== Count 18+ VN ===================== 
SELECT COUNT(r.title)
FROM releases_vn rv
JOIN vn v ON rv.vid = v.id
JOIN releases r ON rv.id = r.id
WHERE minage=18;

-- ===================== Count Total VN in VNDB ===================== 
SELECT COUNT(r.title)
FROM releases_vn rv
JOIN vn v ON rv.vid = v.id
JOIN releases r ON rv.id = r.id;

-- =====================  Count Total User of VNDB ===================== 
SELECT COUNT(id)
FROM users;

-- =====================  Non H Anime Adapted From Visual Novel ===================== 
SELECT v.title AS "vn_title", a.title_romaji AS "anime_title", a.type, a.year AS "anime_year", MIN(r.released) AS "vn_released_date", 'https://anidb.net/anime/' || a.id AS "anime_link", 'https://vndb.org/' || v.id AS "vn_link"
FROM vn v
JOIN releases_vn rv ON v.id = rv.vid
JOIN releases r ON rv.id = r.id
JOIN vn_anime va ON v.id = va.id
JOIN anime a ON va.aid = a.id
GROUP BY v.title, a.title_romaji, a.type, a.year, a.id, v.id
HAVING (a.year > MIN(r.released)/10000 OR a.year IS NULL) AND (a.type <> 'ova' OR a.type IS NULL)
ORDER BY a.year DESC;

-- =====================  Review of Specific VN ===================== 
SELECT uv.uid, uv.vid, uv.added, uv.lastmod, uv.vote_date, uv.started, uv.finished, uv.vote, uv.notes
FROM ulist_vns uv
JOIN vn v ON v.id = uv.vid
-- Change the Title of Visual Novel
WHERE v.title = 'Summer Pockets' 
AND (notes <> '' OR vote IS NOT NULL)
ORDER BY added DESC;

-- =====================  VN in Indonesian Language ===================== 
SELECT v.title, r.released, v.original, v.olang AS "original_language", r.website
FROM releases_lang rlang
JOIN releases r ON rlang.id = r.id
JOIN releases_vn rvn ON r.id = rvn.id
JOIN vn v ON v.id = rvn.vid
-- You can change this to specific the language
WHERE lang='id'
ORDER BY v.c_popularity DESC;

-- =====================  Numbers of VN by Platform ===================== 
SELECT platform, COUNT(id)
FROM releases_platforms
GROUP BY platform
ORDER BY COUNT(id) DESC;

-- =====================  Numbers of VN by Minimum Ages ===================== 
SELECT minage, COUNT(r.title)
FROM releases_vn rv
JOIN vn v ON rv.vid = v.id
JOIN releases r ON rv.id = r.id
GROUP BY minage;

-- =====================  Relation Between Producer ===================== 
SELECT pr.id, pr.pid, pr.relation, p1.name AS "p1_name", p2.name AS "p2_name"
FROM producers_relations pr
JOIN producers p1 ON pr.id=p1.id
JOIN producers p2 ON pr.pid=p2.id;

-- =====================  VN and Their Staff ===================== 
SELECT vs.id, vs.aid, vs.role, v.title, sa.name
FROM vn_staff vs
JOIN vn v ON v.id = vs.id
JOIN staff_alias sa ON sa.aid = vs.aid;

-- =====================  Staff with Most Works =====================
SELECT sa.name, COUNT(sa.name), 'https://vndb.org/' || sa.id AS "vndb_link"
FROM vn_staff vs
JOIN vn v ON v.id = vs.id
JOIN staff_alias sa ON sa.aid = vs.aid
GROUP BY sa.name, sa.id
ORDER BY COUNT(sa.name) DESC;

-- =====================  Staff with Most Works in Specific Producer =====================
SELECT sa.name, COUNT(sa.name)
FROM vn_staff vs
JOIN vn v ON v.id = vs.id
JOIN staff_alias sa ON sa.aid = vs.aid
JOIN releases_vn rv ON rv.vid = v.id
JOIN releases r ON r.id = rv.id
JOIN releases_producers rp ON rp.id = r.id
JOIN producers p ON p.id = rp.pid
-- You can change here
WHERE p.name = 'Key'
GROUP BY sa.name
ORDER BY COUNT(sa.name) DESC;

-- =====================  Official VN Relation =====================
SELECT v1.title AS "Source", v2.title AS "Target"
FROM vn_relations vr
JOIN vn v1 ON v1.id = vr.id
JOIN vn v2 ON v2.id = vr.vid
WHERE vr.official = true;