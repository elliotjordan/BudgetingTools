SELECT 

  --* comment this out as we want specific fields fr Postgres function & rename

  --/* comment this out, permit testing
  -- value in parentheses s/b technical field name
"Biennium", -- Biennium (biennium)
"Bus Unit", -- Bus Unit (inst)
"KFS Chart", -- KFS Chart (chart)
"Rptg Chrt", -- Rptg Chrt (derived), break out IU SOM
"RC Code", -- RC Code (b2_rc)
"RC Name", -- RC Name (CHP_RCB_MATRIX_T.RC_NM)
"Account Number", -- Account Number (account)
"Account Name", -- Account Name (account_nm)
"RCB Excl", -- RCB Excl (CHP_RCB_MATRIX_T.RCB_EXCL)
"School", -- School (CHP_RCB_MATRIX_T.SCHOOL)
"Tuition Group", -- Tuition Group (selgroup)
"Tuition Group Descr", -- Tuition Group Descr (CHP_SEL_GRP_T.DESCR)
"TG Excl",  -- TG Excl (derived), allows certain non-rev fee codes like ACP, G901, OVST t/b excl
"Fee Code", -- Fee Code (feecode)
"Fee Code Descr", -- Fee Code Descr (feedescr)
"Distance", -- Distance (b2_fee_distance)
"Career Categ", -- Career Categ (CHP_ACAD_CAREER_T.LEVEL_CD), collapse 7 academic careers to 3 (UGRD/GRAD/PROF)
"Level", -- Level (CHP_ACAD_CAREER_T.SLEVEL), Undergraduate/Graduate
"Term Code", -- Term Code (sesn)
"Acad Term",-- Acad Term (derived), re-map 2-char codes to short descr's (e.g., 'FL', 'Fall')
"Term Long Descr", -- Term Long Descr (CHP_TERM_T.Expanded_Descr)
"Term Shrt Descr", -- Term Shrt Descr (CHP_TERM_T.DESCRSHORT)
"Projector Residency", -- Projector Residency (res)
"Resdcy Desc", -- Resdcy Desc (CHP_RESIDENCY_T.res_grp)
"Object Code", -- Object Code (b2_objcd)
"Object Code Shrt Name", -- Object Code Shrt Name (CHP_OBJ_MTRX_T.FIN_OBJ_CD_SHRT_NM)
"ProForma Cd", -- ProForma Cd (BCN_OBJ_CD_ROLLUP_GV.PROFORMA_CD), derived - chg 0701/0801/0901/1001 to '09de', chg banded obj's to '10ms' pseudo-pro forma codes
"ProForma Nm", -- ProForma Nm (BCN_OBJ_CD_ROLLUP_GV.PROFORMA_NAME), derived - chg 0701/0801/0901/1001 to 'Undifferentiated Dist Ed', chg banded obj's to 'Campus Mkt Share'
"Natural Object Code", -- Natural Object Code (gl_obj_cd_orig)
"Natural Object Code Name", -- Natural Object Code Name (fin_obj_cd_nm_orig)
"UIRR Rpt Categ", -- UIRR Rpt Categ (derived), classify fee codes into categ's - to allow tie-out to UIRR rptd CHs (DUAL/OVST/OCC/EXCL/REG)

"B1 Camp Proj Hrs Yr2" as "Camp Proj Hrs_Yr2 Orig", -- Camp Proj Hrs_Yr2 Orig (b1_projhrs_yr2), FY23 Orig Camp Proj Hrs
"B1 Escltd Eff Rt Yr2" as "Escltd Eff Rt_Yr2 Orig", -- Escltd Eff Rt_Yr2 Orig (b1_adj_escl_rate_yr2), FY23 Orig Escltd Rate
"B1 Escltd Tuit Rev Yr2" as "Tuit Rev Yr2 Orig", -- Tuit Rev Yr2 Orig (calc'd), ROUND(b1_adj_escl_rate_yr2 * b1_projhrs_yr2, 2), FY23 Orig Tuition Revenue
"B2 Heads" as "FY23 Heads", -- Heads Yr2 (b2_headcount), interface: Heads, FY23 Heads
"B2 Act CH" as "FY22 Cr Hrs", -- Act CH Yr2 (b2_hours), interface: Cr Hrs (FY22 Actual as of Census), FY22 Cr Hrs
"B2 UBO Proj Hrs Yr2" as "FY23 Enroll Study Hrs", -- UBO Proj Hrs_Yr2 Revsd (b2_machhrs_yr2), interface: Enrollment Study Projection Hours (machine hrs), FY23 Enroll Study Hrs
"B2 Camp Proj Hrs Yr2" as "Camp Proj Hrs_Yr2 Revsd", -- Camp Proj Hrs_Yr2 Revsd (b2_projhrs_yr2), interface: Campus Projected Hours, FY23 Rev Camp Proj Hrs
"B2 Const Eff Rt Yr2" as "FY23 Rev Const Eff Rate", -- Const Eff Rt Yr2 Revsd (b2_adj_rate), FY22 Effective Rate (Vc) using FY22 fcp data, FY23 Rev Const Eff Rate
"B2 Escltd Eff Rt Yr2" as "Escltd Eff Rt_Yr2 Revsd", -- Escltd Eff Rt_Yr2 Revsd (b2_adj_escl_rate_yr2), interface: Escalated Rate (V1), FY23 Rev Escltd Rate
  --FY23 escalated rates at Recommended to BOT pct incrses (FY23)
"B2 Enroll Study Tuit Revenue Yr2" as "FY23 Enroll Study Tuit Revenue", -- UBO Tuit Rev Yr2 (calc'd), ROUND(b2_adj_escl_rate_yr2 * b2_machhrs_yr2, 2), FY23 Enroll Study Tuit Revenue
"B2 Const Tuit Rev Yr2" as "FY23 Const Rev Tuition Revenue", -- Const Tuit Rev Yr2 Revised (calc'd), ROUND(b2_adj_rate * b2_projhrs_yr2, 2), FY23 Const Rev Tuition Revenue
  -- campus proj'd rev FY23 hrs @ FY22 const eff rates
"B2 Escltd Tuit Rev Yr2" as "Tuit Rev Yr2 Revisd", -- Tuit Rev Yr2 Revisd (calc'd), interface: Estimated Revenue (Cr Hrs * Escalated Rate), FY23 Rev Tuition Revenue
  --ROUND(b2_adj_escl_rate_yr2 * b2_projhrs_yr2, 2), campus proj'd rev FY23 hrs @ escalated FY22 const eff rates
"Yr2 Escltd Incrmtl Rev" as "Yr2 Escltd Incrmtl Rev", -- Yr 1 vs. Yr 2 Rev, (b2_adj_escl_rate_yr2 * b2_projhrs_yr2) - (b1_adj_escl_rate_yr1 * b1_projhrs_yr1), Yr2 Escltd Incrmtl Rev
  -- don't have enuf fields to validate this calc??
"Yr2 Rate Chg" as "Yr2 Rate Chg", -- new (calc'd), b2_projhrs_yr2 * (b2_adj_escl_rate_yr2 - b1_adj_escl_rate_yr2). Doesn't seem correct. FY23 Rate Chg Rev
"Yr2 $ Chg" as "Yr 2 $ Chg", -- Yr 2 $ Chg (calc'd), FY23 Rev Tuition Revenue - FY23 Orig Tuition Revenue, diff really using updated FCP rates vs. fr last spr &
  -- revised camp proj hrs. This is really mis-labeled. (b2_adj_escl_rate_yr2 * b2_projhrs_yr2) - (b1_adj_escl_rate_yr2 * b1_projhrs_yr2), FY23 $ Chg Rev vs Orig


"RC Code" as "RC Code2", -- allow t/b used as filter & row field in visual
"RC Name" as "RC Name2", -- allow t/b used as filter & row field in visual
"Account Name" as "Account Name2", -- allow t/b used as filter & row field in visual
'' as s1, -- allow to be used as a separator field on 'BC_Prepare' BC import template data staging tab
'' as s2 -- allow to be used as a separator field on 'BC_Prepare' BC import template data staging tab

  --*/ comment this out, permit testing
  
FROM ch_user.b2_rpt_chp_report_v1  
  --ch_user.rpt_chp_report_v1() -- this is Paddy Adam's new Postgres function allowing val rpt data dump to be parameterized
  -- formerly pulled fr CHP_HTP_T & a host of lookup tbls, he is doing same in the function
  
/*
-- for testing only
WHERE "Escltd Eff Rt Yr2" <> "Escltd Eff Rt Yr1" -- has been rate chg
AND "Escltd Eff Rt Yr1" <> 0
AND "Camp Proj Hrs Yr2" <> "Camp Proj Hrs Yr1" -- proj'd hrs have been revised
AND "Camp Proj Hrs Yr1" <> 0
AND "Account Number" = '1045087'
AND "Fee Code" = 'GRADR'
AND "Term Code" = 'FL'
*/

--WHERE b2_adj_escl_rate_yr2 <> b1_adj_escl_rate_yr2 -- has been rate chg
--AND b2_projhrs_yr2 <> b1_projhrs_yr2 -- proj'd hrs have been revised

/*
--dumps raw data fields for comparison w/ above
SELECT *
FROM ch_user.b2_rpt_chp_report_v1
  --ch_user.rpt_chp_report_v1()
--WHERE ROWNUM = 1

  -- for testing only, the 1st part of WHERE clause needs reworking
--WHERE "Escltd Eff Rt Yr2" <> "Escltd Eff Rt Yr1" -- has been rate chg
--AND "Escltd Eff Rt Yr1" <> 0
--AND "Camp Proj Hrs Yr2" <> "Camp Proj Hrs Yr1" -- proj'd hrs have been revised
--AND "Camp Proj Hrs Yr1" <> 0
WHERE "Account Number" = '1045087'
AND "Fee Code" = 'GRADR'
AND "Term Code" = 'FL'
*/
