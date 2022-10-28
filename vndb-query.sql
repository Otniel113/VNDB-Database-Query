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

-- =====================  Count Total User of VNDB ===================== 
SELECT COUNT(id)
FROM users;