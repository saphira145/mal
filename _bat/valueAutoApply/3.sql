--
-- 小回りが利く (ID:3)
--
-- 選定の目安: 上位 20% 以上
-- 現在のしきい値: 4.4m以下
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
  3,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.turningCircle > 0
  AND CAST(G.turningCircle AS DECIMAL(4,2)) <= 4.4
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID
ORDER BY
  G.turningCircle;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  3,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.turningCircle > 0
  AND CAST(G.turningCircle AS DECIMAL(4,2)) <= 4.4
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID
ORDER BY
  G.turningCircle;
