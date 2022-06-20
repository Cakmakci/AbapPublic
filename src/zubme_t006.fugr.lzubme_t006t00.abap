*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 23.02.2022 at 12:24:39
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T006......................................*
DATA:  BEGIN OF STATUS_ZUBME_T006                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T006                    .
CONTROLS: TCTRL_ZUBME_T006
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T006                    .
TABLES: ZUBME_T006                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
