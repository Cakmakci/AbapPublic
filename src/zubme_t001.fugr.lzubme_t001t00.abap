*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 05.01.2022 at 11:18:39
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T001......................................*
DATA:  BEGIN OF STATUS_ZUBME_T001                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T001                    .
CONTROLS: TCTRL_ZUBME_T001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T001                    .
TABLES: ZUBME_T001                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
