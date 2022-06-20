*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 23.02.2022 at 15:24:11
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T004......................................*
DATA:  BEGIN OF STATUS_ZUBME_T004                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T004                    .
CONTROLS: TCTRL_ZUBME_T004
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T004                    .
TABLES: *ZUBME_T004T                   .
TABLES: ZUBME_T004                     .
TABLES: ZUBME_T004T                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
