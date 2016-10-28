--
-- 100V電源(コンセント)がある (ID:38)
-- 最終更新: 2014-02-13
--
-- seatInterior.carInPowerName のうち、
-- 「オプション：」以降を取り除いた
-- 文字列をチェックしている.
--

--
-- 標準 2WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  38,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  (SELECT DISTINCT
    carGradeID,
    carInPowerType,
    CASE LOCATE('オプション：', `carInPowerName`)
      WHEN 0 THEN carInPowerName
      ELSE SUBSTRING(`carInPowerName`, 1, LOCATE('オプション：', `carInPowerName`) - 1)
    END AS carInPowerName
  FROM
    seatInterior
  ) AS I
WHERE
  I.carInPowerType = 2
  AND I.carInPowerName LIKE '%１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：ＡＣパワーサプライ（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：アクセサリーソケット（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：アクセサリーコンセント（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＤＯＰ：マルチアウトレット（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：ＡＣパワーサプライ（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：アクセサリーソケット（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：アクセサリーコンセント（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：マルチアウトレット（ＡＣ１００Ｖ%'
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s2wdCarGradeID = G.carGradeID
  AND G.carGradeID = I.carGradeID;
--
-- 標準 4WD
--
REPLACE INTO
  carTheme
SELECT
  G.makerCode,
  G.modelCode,
  38,
  now(),
  0
FROM
  model AS M,
  carGrade AS G,
  (SELECT DISTINCT
    carGradeID,
    carInPowerType,
    CASE LOCATE('オプション：', `carInPowerName`)
      WHEN 0 THEN carInPowerName
      ELSE SUBSTRING(`carInPowerName`, 1, LOCATE('オプション：', `carInPowerName`) - 1)
    END AS carInPowerName
  FROM
    seatInterior
  ) AS I
WHERE
  I.carInPowerType = 2
  AND I.carInPowerName LIKE '%１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：ＡＣパワーサプライ（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：アクセサリーソケット（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＭＯＰＴ：アクセサリーコンセント（ＡＣ１００Ｖ%'
  AND I.carInPowerName NOT LIKE '%ＤＯＰ：マルチアウトレット（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：ＡＣパワーサプライ（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：アクセサリーソケット（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：アクセサリーコンセント（ＡＣ１００Ｖ%'
--  AND I.carInPowerName NOT LIKE '%オプション：マルチアウトレット（ＡＣ１００Ｖ%'
  AND M.makerCode = G.makerCode
  AND M.modelCode = G.modelCode
  AND M.s4wdCarGradeID = G.carGradeID
  AND G.carGradeID = I.carGradeID;
