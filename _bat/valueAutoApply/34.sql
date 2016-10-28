--
-- お客様を送迎する (ID:34)
-- 旧: 7人以上の乗車が可能
-- 2014-03-28 名称変更
--
-- 条件: 定員7人以上
-- 判定方法: capacity が 7 以上
-- 最終更新: 2014-01-31
--

--
-- 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  34,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.capacity >= 7
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID;
--
-- 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  34,
  now(),
  0
FROM
  model AS M,
  carGrade AS G
WHERE
  G.capacity >= 7
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID;
