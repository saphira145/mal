--
-- 立体駐車場に入庫できる (ID:36)
--
-- 現在のしきい値: 高さ 1550mm 未満 + 車幅 1850mm 未満
-- 最終更新: 2014-01-31
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  36,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.totalHeight < 1550
  AND G.totalWidth < 1850
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  36,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.totalHeight < 1550
  AND G.totalWidth < 1850
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
