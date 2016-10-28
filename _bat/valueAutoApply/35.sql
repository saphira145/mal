--
-- 旧: お客様を送迎する (ID:35)
-- 2014-03-28 無効にすることに決定
--
-- 条件: 定員8人以上
-- 判定方法: capacity が 8 以上
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
  35,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.capacity >= 8
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
  35,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.capacity >= 8
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
